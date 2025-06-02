//
//  Camera.swift
//  C3-4T2D
//
//  Created by Hwnag Seyeon on 5/29/25.
//

import AVFoundation
import CoreImage
import os.log
import UIKit

// MARK: - 카메라 기능 구현 클래스

class Camera: NSObject, AVCapturePhotoCaptureDelegate, AVCaptureVideoDataOutputSampleBufferDelegate {
    // MARK: - 세션 및 장치 구성

    private let captureSession = AVCaptureSession()
    private var isCaptureSessionConfigured = false

    private var deviceInput: AVCaptureDeviceInput?
    private var photoOutput: AVCapturePhotoOutput?
    private var videoOutput: AVCaptureVideoDataOutput?

    private var sessionQueue: DispatchQueue!

    private let logger = Logger(subsystem: "com.seyeon.C3-4T2D", category: "Camera")

    // MARK: - 사용 가능한 장치 정리

    private var allCaptureDevices: [AVCaptureDevice] {
        AVCaptureDevice.DiscoverySession(
            deviceTypes: [
                .builtInTrueDepthCamera,
                .builtInDualCamera,
                .builtInDualWideCamera,
                .builtInWideAngleCamera
            ],
            mediaType: .video,
            position: .unspecified
        ).devices
    }

    private var frontCaptureDevices: [AVCaptureDevice] {
        allCaptureDevices.filter { $0.position == .front }
    }

    private var backCaptureDevices: [AVCaptureDevice] {
        allCaptureDevices.filter { $0.position == .back }
    }

    private var captureDevices: [AVCaptureDevice] {
        var devices = [AVCaptureDevice]()
        #if os(macOS) || (os(iOS) && targetEnvironment(macCatalyst))
        devices += allCaptureDevices
        #else
        if let back = backCaptureDevices.first { devices.append(back) }
        if let front = frontCaptureDevices.first { devices.append(front) }
        #endif
        return devices
    }

    private var availableCaptureDevices: [AVCaptureDevice] {
        captureDevices
            .filter { $0.isConnected }
            .filter { !$0.isSuspended }
    }

    private var captureDevice: AVCaptureDevice? {
        didSet {
            guard let device = captureDevice else { return }
            logger.debug("Using capture device: \(device.localizedName)")
            sessionQueue.async {
                self.updateSessionForCaptureDevice(device)
            }
        }
    }

    // MARK: - 상태

    var isRunning: Bool { captureSession.isRunning }
    var isUsingFrontCaptureDevice: Bool {
        guard let device = captureDevice else { return false }
        return frontCaptureDevices.contains(device)
    }

    var isUsingBackCaptureDevice: Bool {
        guard let device = captureDevice else { return false }
        return backCaptureDevices.contains(device)
    }

    var isPreviewPaused = false

    // MARK: - 비동기 스트림 출력

    private var addToPhotoStream: ((AVCapturePhoto) -> Void)?
    private var addToPreviewStream: ((CIImage) -> Void)?

    lazy var previewStream: AsyncStream<CIImage> = AsyncStream { continuation in
        addToPreviewStream = { ciImage in
            if !self.isPreviewPaused {
                continuation.yield(ciImage)
            }
        }
    }

    lazy var photoStream: AsyncStream<AVCapturePhoto> = AsyncStream { continuation in
        addToPhotoStream = { photo in
            continuation.yield(photo)
        }
    }

    // MARK: - 초기화

    override init() {
        super.init()
        initialize()
    }

    private func initialize() {
        sessionQueue = DispatchQueue(label: "session queue")

        captureDevice = availableCaptureDevices.first ?? AVCaptureDevice.default(for: .video)

        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateForDeviceOrientation),
            name: UIDevice.orientationDidChangeNotification,
            object: nil
        )
    }

    // MARK: - 세션 구성

    private func configureCaptureSession(completionHandler: (_ success: Bool) -> Void) {
        var success = false

        captureSession.beginConfiguration()
        defer {
            captureSession.commitConfiguration()
            completionHandler(success)
        }

        guard let device = captureDevice,
              let input = try? AVCaptureDeviceInput(device: device)
        else {
            logger.error("Failed to obtain video input.")
            return
        }

        let photoOutput = AVCapturePhotoOutput()
        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "VideoDataOutputQueue"))

        captureSession.sessionPreset = .photo
//        captureSession.sessionPreset = .hd1280x720

        guard captureSession.canAddInput(input),
              captureSession.canAddOutput(photoOutput),
              captureSession.canAddOutput(videoOutput)
        else {
            logger.error("Failed to add input/output to capture session.")
            return
        }

        captureSession.addInput(input)
        captureSession.addOutput(photoOutput)
        captureSession.addOutput(videoOutput)

        deviceInput = input
        self.photoOutput = photoOutput
        self.videoOutput = videoOutput

        photoOutput.isHighResolutionCaptureEnabled = true
        photoOutput.maxPhotoQualityPrioritization = .quality

        updateVideoOutputConnection()

        isCaptureSessionConfigured = true
        success = true
    }

    // MARK: - 권한 확인

    private func checkAuthorization() async -> Bool {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            logger.debug("Camera access authorized.")
            return true
        case .notDetermined:
            logger.debug("Camera access not determined.")
            sessionQueue.suspend()
            let status = await AVCaptureDevice.requestAccess(for: .video)
            sessionQueue.resume()
            return status
        case .denied:
            logger.debug("Camera access denied.")
            return false
        case .restricted:
            logger.debug("Camera access restricted.")
            return false
        @unknown default:
            return false
        }
    }

    // MARK: - 세션 시작/중지

    func start() async {
        let authorized = await checkAuthorization()
        guard authorized else {
            logger.error("Camera access was not authorized.")
            return
        }

        if isCaptureSessionConfigured {
            if !captureSession.isRunning {
                sessionQueue.async {
                    self.captureSession.startRunning()
                }
            }
        } else {
            sessionQueue.async {
                self.configureCaptureSession { success in
                    if success {
                        self.captureSession.startRunning()
                    }
                }
            }
        }
    }

    func stop() {
        guard isCaptureSessionConfigured else { return }

        if captureSession.isRunning {
            sessionQueue.async {
                self.captureSession.stopRunning()
            }
        }
    }

//    // MARK: - 카메라 전환
//
//    func switchCaptureDevice() {
//        if let current = captureDevice,
//           let index = availableCaptureDevices.firstIndex(of: current)
//        {
//            let nextIndex = (index + 1) % availableCaptureDevices.count
//            captureDevice = availableCaptureDevices[nextIndex]
//        } else {
//            captureDevice = AVCaptureDevice.default(for: .video)
//        }
//    }

    // MARK: - 사진 촬영

    func takePhoto() {
        guard let photoOutput = photoOutput else { return }

        sessionQueue.async {
            var settings = AVCapturePhotoSettings()

            if photoOutput.availablePhotoCodecTypes.contains(.hevc) {
                settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.hevc])
            }

            let isFlashAvailable = self.deviceInput?.device.isFlashAvailable ?? false
            settings.flashMode = isFlashAvailable ? .auto : .off
            settings.isHighResolutionPhotoEnabled = true

            if let previewType = settings.availablePreviewPhotoPixelFormatTypes.first {
                settings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String: previewType]
            }

            settings.photoQualityPrioritization = .balanced

            if let connection = photoOutput.connection(with: .video),
               connection.isVideoOrientationSupported,
               let orientation = self.videoOrientationFor(self.deviceOrientation)
            {
                connection.videoOrientation = orientation
            }

            photoOutput.capturePhoto(with: settings, delegate: self)
        }
    }

    // MARK: - Flash 제어

    func toggleFlash(on: Bool) {
        sessionQueue.async {
            guard let device = self.captureDevice, device.hasTorch else {
                self.logger.debug("Device does not support torch (flash).")
                return
            }

            do {
                try device.lockForConfiguration()
                if on {
                    try device.setTorchModeOn(level: AVCaptureDevice.maxAvailableTorchLevel)
                } else {
                    device.torchMode = .off
                }
                device.unlockForConfiguration()
                self.logger.debug("Torch mode set to \(on ? "ON" : "OFF")")
            } catch {
                self.logger.error("Failed to toggle flash: \(error.localizedDescription)")
            }
        }
    }

    // MARK: - 연결 업데이트

    private func updateSessionForCaptureDevice(_ device: AVCaptureDevice) {
        guard isCaptureSessionConfigured else { return }

        captureSession.beginConfiguration()
        defer { captureSession.commitConfiguration() }

        for input in captureSession.inputs {
            if let input = input as? AVCaptureDeviceInput {
                captureSession.removeInput(input)
            }
        }

        if let newInput = deviceInputFor(device: device),
           !captureSession.inputs.contains(newInput),
           captureSession.canAddInput(newInput)
        {
            captureSession.addInput(newInput)
        }

        updateVideoOutputConnection()
    }

    private func updateVideoOutputConnection() {
        if let output = videoOutput,
           let connection = output.connection(with: .video),
           connection.isVideoMirroringSupported
        {
            connection.isVideoMirrored = isUsingFrontCaptureDevice
        }
    }

    private func deviceInputFor(device: AVCaptureDevice?) -> AVCaptureDeviceInput? {
        guard let device = device else { return nil }
        do {
            return try AVCaptureDeviceInput(device: device)
        } catch {
            logger.error("Error getting capture device input: \(error.localizedDescription)")
            return nil
        }
    }

    // MARK: - 기기 방향 처리

    private var deviceOrientation: UIDeviceOrientation {
        var orientation = UIDevice.current.orientation
        if orientation == .unknown {
            orientation = UIScreen.main.orientation
        }
        return orientation
    }

    @objc
    func updateForDeviceOrientation() {
        // TODO: 사용할 경우 구현
    }

    private func videoOrientationFor(_ orientation: UIDeviceOrientation) -> AVCaptureVideoOrientation? {
        switch orientation {
        case .portrait: return .portrait
        case .portraitUpsideDown: return .portraitUpsideDown
        case .landscapeLeft: return .landscapeRight
        case .landscapeRight: return .landscapeLeft
        default: return nil
        }
    }

    // MARK: - AVCapturePhotoCaptureDelegate

    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error {
            logger.error("Error capturing photo: \(error.localizedDescription)")
            return
        }
        addToPhotoStream?(photo)
    }

    // MARK: - AVCaptureVideoDataOutputSampleBufferDelegate

    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = sampleBuffer.imageBuffer else { return }

        if connection.isVideoOrientationSupported,
           let orientation = videoOrientationFor(deviceOrientation)
        {
            connection.videoOrientation = orientation
        }

        addToPreviewStream?(CIImage(cvPixelBuffer: pixelBuffer))
    }
}

// MARK: - UIScreen 확장 (기기 방향)

private extension UIScreen {
    var orientation: UIDeviceOrientation {
        let point = coordinateSpace.convert(CGPoint.zero, to: fixedCoordinateSpace)
        if point == .zero {
            return .portrait
        } else if point.x != 0 && point.y != 0 {
            return .portraitUpsideDown
        } else if point.x == 0 && point.y != 0 {
            return .landscapeRight
        } else if point.x != 0 && point.y == 0 {
            return .landscapeLeft
        } else {
            return .unknown
        }
    }
}
