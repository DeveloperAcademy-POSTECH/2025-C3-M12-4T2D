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
            Item.self,
            
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            ProjectList()
        }
        .modelContainer(sharedModelContainer)
    }
}
