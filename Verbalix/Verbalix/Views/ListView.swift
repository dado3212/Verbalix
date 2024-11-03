//
//  ContentView.swift
//  Verbalix
//
//  Created by Alex Beals on 8/20/24.
//

import SwiftUI
import SwiftData
import AVFoundation

struct ListView: View {
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
  @EnvironmentObject var speechManager: SpeechManager
  let word: String
  
  init(word: String) {
    self.word = word
  }
  
  var body: some View {
    Button(action: {
      speechManager.speak(text: word)
    }) {
      Image(systemName: "speaker.wave.2.fill")
        .foregroundColor(.blue)
        .font(.system(size: 16))
    }
    .buttonStyle(PlainButtonStyle())
  }
}

#Preview {
  
  let config = ModelConfiguration(isStoredInMemoryOnly: true)
  let container = try! ModelContainer(for: Word.self, configurations: config)
  
  container.mainContext.insert(Word(word: "feculent", definitions: ["Dirty with faeces or other impurities"], dateAdded: Date()))
  
  return ListView()
    .modelContainer(container)
}
