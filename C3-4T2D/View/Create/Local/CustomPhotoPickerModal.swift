import SwiftUI
import Photos

struct CustomPhotoPickerModal: View {
    @Binding var isPresented: Bool
    let onPhotoPicked: (UIImage) -> Void
    let onCameraTapped: () -> Void

    enum AlbumFilter: String, CaseIterable {
        case recents = "최근 항목"
        case favorites = "즐겨찾기"
    }
    @State private var selectedFilter: AlbumFilter = .recents

    @State private var photoAssets: [PHAsset] = []
    @State private var thumbnails: [UIImage] = []
    @State private var isLoading = false

    private let gridColumns = Array(repeating: GridItem(.flexible(), spacing: 2), count: 3)
    private let cellSize: CGFloat = (UIScreen.main.bounds.width - 20) / 3

    var body: some View {
        VStack(spacing: 0) {
            // 헤더
            HStack {
                Button("취소") { isPresented = false }
                    .foregroundColor(.gray)
                Spacer()
                Text("사진 추가")
                    .font(.system(size: 18, weight: .semibold))
                Spacer()
                Spacer().frame(width: 44)
            }
            .padding(.horizontal)
            .padding(.top, 12)
            .padding(.bottom, 8)

            // 상단 필터 바
            HStack(spacing: 0) {
                ForEach(AlbumFilter.allCases, id: \.self) { filter in
                    Button(action: {
                        selectedFilter = filter
                        loadPhotos()
                    }) {
                        Text(filter.rawValue)
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(selectedFilter == filter ? .black : Color(.darkGray))
                            .frame(maxWidth: .infinity)
                            .frame(height: 32)
                            .background(
                                Group {
                                    if selectedFilter == filter {
                                        Color(.systemGray5)
                                    } else {
                                        Color.clear
                                    }
                                }
                            )
                    }
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: 12,
                            style: .continuous
                        )
                    )
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color(.systemBackground))
            )
            .frame(height: 32)
            .padding(.horizontal, 16)
            .padding(.bottom, 2)


            // 그리드
            ScrollView {
                LazyVGrid(columns: gridColumns, spacing: 2) {
                    // 카메라 버튼
                    Button(action: onCameraTapped) {
                        ZStack {
                            Rectangle()
                                .fill(Color.yellow.opacity(0.15))
                                .frame(width: cellSize, height: cellSize)
                            Image(systemName: "camera.fill")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(.yellow)
                        }
                    }
                    .frame(width: cellSize, height: cellSize)
                    // 썸네일들
                    ForEach(photoAssets.indices, id: \.self) { idx in
                        let asset = photoAssets[idx]
                        Button(action: {
                            let manager = PHImageManager.default()
                            let options = PHImageRequestOptions()
                            options.deliveryMode = .highQualityFormat
                            options.isSynchronous = false
                            options.resizeMode = .none
                            manager.requestImage(
                                for: asset,
                                targetSize: PHImageManagerMaximumSize,
                                contentMode: .aspectFit,
                                options: options
                            ) { image, _ in
                                if let image = image {
                                    onPhotoPicked(image)
                                }
                            }
                        }) {
                            Image(uiImage: thumbnails[idx])
                                .resizable()
                                .scaledToFill()
                                .frame(width: cellSize, height: cellSize)
                                .clipped()
                        }
                        .frame(width: cellSize, height: cellSize)
                    }
                }
                .padding(6)
            }
        }
        .background(Color(.systemBackground))
        .onAppear(perform: loadPhotos)
    }

    private func loadPhotos() {
        photoAssets = []
        thumbnails = []
        isLoading = true
        PHPhotoLibrary.requestAuthorization { status in
            if status == .authorized || status == .limited {
                let fetchOptions = PHFetchOptions()
                fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
                fetchOptions.fetchLimit = 100
                let assets: PHFetchResult<PHAsset>
                switch selectedFilter {
                case .recents:
                    assets = PHAsset.fetchAssets(with: .image, options: fetchOptions)
                case .favorites:
                    let favorites = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumFavorites, options: nil)
                    if let collection = favorites.firstObject {
                        assets = PHAsset.fetchAssets(in: collection, options: fetchOptions)
                    } else {
                        assets = PHFetchResult<PHAsset>()
                    }
                }
                var loadedAssets: [PHAsset] = []
                assets.enumerateObjects { asset, _, _ in
                    loadedAssets.append(asset)
                }
                DispatchQueue.main.async {
                    self.photoAssets = loadedAssets
                    self.loadThumbnails()
                }
            }
        }
    }

    private func loadThumbnails() {
        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.isSynchronous = false
        options.resizeMode = .exact
        let targetSize = CGSize(width: cellSize * 2, height: cellSize * 2)
        thumbnails = Array(repeating: UIImage(), count: photoAssets.count)
        for (idx, asset) in photoAssets.enumerated() {
            manager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: options) { image, _ in
                if let image = image {
                    DispatchQueue.main.async {
                        if idx < thumbnails.count {
                            thumbnails[idx] = image
                        }
                    }
                }
            }
        }
    }
} 
