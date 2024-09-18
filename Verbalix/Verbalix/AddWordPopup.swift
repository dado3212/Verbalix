//
//  AddWordPopup.swift
//  Verbalix
//
//  Created by Alex Beals on 9/17/24.
//

import Foundation
import SwiftUI

struct AddWordPopup: View {
  @Binding var showPopup: Bool
  @State private var word = ""
  @State private var definition: String = ""
  
  var addWord: (String, String) -> Void
  
  var body: some View {
    NavigationView {
      Form {
        Section(header: Text("New Word")) {
          TextField("Word", text: $word).textInputAutocapitalization(.never)
        }
        
        Section {
          Text("\(definition)")
        }
        
        Button("Fetch Definition") {
          fetchDefinition(for: word)
//          showPopup = false
        }.disabled(word.isEmpty)
        
        Button("Add") {
          addWord(word, definition)
          showPopup = false
        }
        .disabled(word.isEmpty || definition.isEmpty)
      }
      .navigationTitle("Add Word")
      .navigationBarItems(leading: Button("Cancel") {
        showPopup = false
      })
    }
  }
  
  private func fetchDefinition(for word: String) {
    // TODO: Handle multi word phrases
    guard let url = URL(string: "https://api.dictionaryapi.dev/api/v2/entries/en/\(word)") else {
      print("Invalid URL")
      return
    }
    
    // TODO: handle errors in UI some way
    URLSession.shared.dataTask(with: url) { data, response, error in
      if let error = error {
        print("Error fetching data: \(error)")
        return
      }
      
      guard let data = data else {
        print("No data received")
        return
      }
      
      do {
        let result = try JSONDecoder().decode([DictionaryEntry].self, from: data)
        // Extract the first definition of the first meaning, if available
        print(result)
        if let firstEntry = result.first, let firstMeaning = firstEntry.meanings.first, let firstDefinition = firstMeaning.definitions.first {
          DispatchQueue.main.async {
            definition = firstDefinition.definition
          }
        } else {
          print("No definition found")
        }
      } catch {
        print("Error decoding data: \(error)")
      }
    }.resume()
  }
}

struct DictionaryEntry: Codable {
    let word: String
    let phonetics: [Phonetic]
    let meanings: [Meaning]
}

struct Phonetic: Codable {
    let text: String
    let audio: String
}

struct Meaning: Codable {
    let partOfSpeech: String
    let definitions: [Definition]
}

struct Definition: Codable {
    let definition: String
}
