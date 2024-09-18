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
  @State private var definitions: [String] = []
  @State private var selectedDefinition: String = ""
  
  var addWord: (String, String) -> Void
  
  var body: some View {
    NavigationView {
      Form {
        Section(header: Text("New Word")) {
          TextField("Word", text: $word).textInputAutocapitalization(.never).autocorrectionDisabled()
        }
        
        if !definitions.isEmpty {
            Section(header: Text("Select Definition")) {
                Picker("Definitions", selection: $selectedDefinition) {
                    ForEach(definitions, id: \.self) { definition in
                        Text(definition).tag(definition)
                    }
                }
            }
        }
        
        Button("Fetch Definition") {
          fetchDefinition(for: word)
//          showPopup = false
        }.disabled(word.isEmpty)
        
        Button("Add") {
          addWord(word, selectedDefinition)
          showPopup = false
        }
        .disabled(word.isEmpty || selectedDefinition.isEmpty)
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
        
        var fetchedDefinitions: [String] = []
        if let firstEntry = result.first {
            for meaning in firstEntry.meanings {
                for definition in meaning.definitions {
                    fetchedDefinitions.append(definition.definition)
                }
            }
        }
        // TODO: Handle if there are no definitions
        DispatchQueue.main.async {
          definitions = fetchedDefinitions
          selectedDefinition = fetchedDefinitions.first ?? ""
        }
      } catch {
        print("Error decoding data: \(error)")
        print("\(data)")
      }
    }.resume()
  }
}

struct DictionaryEntry: Codable {
    let word: String
    let phonetics: [Phonetic]
    let meanings: [Meaning]
    let license: License?
    let sourceUrls: [String]?
}

struct Phonetic: Codable {
    let text: String?
    let audio: String?
    let sourceUrl: String?
    let license: License?
}

struct Meaning: Codable {
    let partOfSpeech: String
    let definitions: [Definition]
    let synonyms: [String]?
    let antonyms: [String]?
}

struct Definition: Codable {
    let definition: String
    let synonyms: [String]?
    let antonyms: [String]?
}

struct License: Codable {
    let name: String
    let url: String
}
