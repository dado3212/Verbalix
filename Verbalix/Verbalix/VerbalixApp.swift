//
//  VerbalixApp.swift
//  Verbalix
//
//  Created by Alex Beals on 8/20/24.
//

import SwiftUI
import SwiftData
import AVFoundation

@main
struct VerbalixApp: App {
  
  init() {
    // Media > Books > com.apple.ibooks-sync.plist
    
//          UserDefaults.standard.register(defaults: [
//              "name": "Taylor Swift",
//              "highScore": 10
//          ])
    let audioSession = AVAudioSession.sharedInstance()
    do {
        try audioSession.setCategory(.playback, mode: .spokenAudio, options: .duckOthers)
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
    } catch {
        print("Audio session setup failed: \(error)")
    }
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
