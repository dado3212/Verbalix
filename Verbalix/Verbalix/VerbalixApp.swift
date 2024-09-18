//
//  VerbalixApp.swift
//  Verbalix
//
//  Created by Alex Beals on 8/20/24.
//

import SwiftUI
import SwiftData

@main
struct VerbalixApp: App {
  
  init() {
    // Media > Books > com.apple.ibooks-sync.plist
    
//          UserDefaults.standard.register(defaults: [
//              "name": "Taylor Swift",
//              "highScore": 10
//          ])
      }
  
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Word.self,
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
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
