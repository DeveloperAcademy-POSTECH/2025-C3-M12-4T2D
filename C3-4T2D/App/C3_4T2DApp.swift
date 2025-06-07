//
//  C3_4T2DApp.swift
//  C3-4T2D
//
//  Created by bishoe on 5/28/25.
//

import SwiftData
import SwiftUI

@main
struct C3_4T2DApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Project.self,
            Post.self,
            User.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
//        WindowGroup {
//            CropView()
//        }
//        .modelContainer(sharedModelContainer)
        
        WindowGroup {
            if let image = UIImage(named: "tmpImage") {
                CropView(
                    image: image,
                    configuration: CropConfiguration(
                        maxMagnificationScale: 5,
                        maskRadius: 150,
                        cropImageCircular: false,
                        rotateImage: true,
                        zoomSensitivity: 1.0,
                        rectAspectRatio: 5.0 / 4.0,
                        texts: .init(),
                        fonts: .init(),
                        colors: .init()
                    ),
                    onComplete: { result in
                        print("✅ Cropped result: \(String(describing: result))")
                    }
                )
            } else {
                Text("❌ 이미지 로드 실패: tmpImage not found")
            }
        }
    }
}
