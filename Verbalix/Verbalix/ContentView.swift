//
//  ContentView.swift
//  Verbalix
//
//  Created by Alex Beals on 8/20/24.
//

import SwiftUI
import SwiftData
import AVFoundation

struct ContentView: View {
  @Environment(\.modelContext) private var modelContext
  @Query private var words: [Word]
  @State private var showPopup = false
  
  var body: some View {
    NavigationSplitView {
      List {
        ForEach(words) { word in
          HStack {
            VStack(alignment: .leading) {
              Text(word.word)
                .font(.title2)
              
              
              Text(word.definitions.first!)
                .font(.subheadline)
            }
            
            Spacer()
            
            PronounceButton(word: word.word)
          }
        }
        .onDelete(perform: deleteItems)
      }
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          EditButton()
        }
        ToolbarItem {
          Button(action: {
            showPopup = true
          }) {
            Label("Add Item", systemImage: "plus")
          }
        }
      }
    } detail: {
      Text("Select an item")
    }
    .sheet(isPresented: $showPopup) {
      AddWordPopup(showPopup: $showPopup, addWord: addItem)
    }
  }
  
  private func addItem(word: String, definitions: Set<String>) {
    withAnimation {
      let newItem = Word(word: word, definitions: definitions, dateAdded: Date())
      modelContext.insert(newItem)
    }
  }
  
  private func deleteItems(offsets: IndexSet) {
    withAnimation {
      for index in offsets {
        modelContext.delete(words[index])
      }
    }
  }
}

// TODO: Select the name only once (also, instructions on how to download)
struct PronounceButton: View {
  let word: String
  private let synthesizer = AVSpeechSynthesizer()
  let voices = AVSpeechSynthesisVoice.speechVoices()
  var voiceToUse: AVSpeechSynthesisVoice?
  
  init(word: String) {
    self.word = word
    voiceToUse = AVSpeechSynthesisVoice(language: "en-US")
    for voice in voices {
      if (voice.quality == .enhanced || voice.quality == .premium) && voice.language == "en-US" {
        voiceToUse = voice
      }
    }
  }
  
  var body: some View {
    Button(action: {
      speakWord(word)
    }) {
      Image(systemName: "speaker.wave.2.fill")
        .foregroundColor(.blue)
        .font(.system(size: 16))
    }
    .buttonStyle(PlainButtonStyle())
  }
  
  private func speakWord(_ word: String) {
//    let audioSession = AVAudioSession.sharedInstance()
//        do {
//            try audioSession.setActive(true)
//        } catch {
//            print("Failed to activate audio session: \(error)")
//        }
//    
    let utterance = AVSpeechUtterance(string: word)
    utterance.voice = voiceToUse
    synthesizer.speak(utterance)
  }
}

#Preview {
  
  let config = ModelConfiguration(isStoredInMemoryOnly: true)
  let container = try! ModelContainer(for: Word.self, configurations: config)
  
  container.mainContext.insert(Word(word: "feculent", definitions: ["Dirty with faeces or other impurities"], dateAdded: Date()))
  
  return ContentView()
    .modelContainer(container)
}
