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
  @State private var selectedDefinitions: Set<String> = []
  @FocusState private var focus: Bool
  
  var addWord: (String, Set<String>) -> Void
  
  var body: some View {
    NavigationView {
      Form {
        Section(header: Text("New Word")) {
          TextField("Word", text: $word)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
            .focused($focus)
            .onAppear {
              focus = true
            }
        }
        
        if !definitions.isEmpty {
          Section(header: Text("Select Definitions")) {
            ScrollView {
              VStack(alignment: .leading) {
                ForEach(definitions, id: \.self) { definition in
                  MultipleSelectionRow(
                    definition: definition,
                    isSelected: Binding(
                      get: { selectedDefinitions.contains(definition) },
                      set: { isSelected in
                        if isSelected {
                          selectedDefinitions.insert(definition)
                        } else {
                          selectedDefinitions.remove(definition)
                        }
                      }
                    )
                  )
                }
              }
              .padding(.vertical)
            }
            .frame(maxHeight: 300) // Adjust height as needed
          }
        }
        
        Button("Fetch Definition") {
          fetchDefinition(for: word)
          focus = false
        }.disabled(word.isEmpty)
        
        Button("Add") {
          addWord(word, selectedDefinitions)
          showPopup = false
        }
        .disabled(word.isEmpty || selectedDefinitions.isEmpty)
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
        }
      } catch {
        print("Error decoding data: \(error)")
        print("\(data)")
      }
    }.resume()
  }
}

struct MultipleSelectionRow: View {
  var definition: String
  @Binding var isSelected: Bool  // Use a Binding to work with Toggle
  
  var body: some View {
    Toggle(isOn: $isSelected) {
      Text(definition)
        .lineLimit(nil)
        .multilineTextAlignment(.leading)
    }
    .toggleStyle(CheckboxToggleStyle())
    .padding(.vertical, 4)
  }
}

struct CheckboxToggleStyle: ToggleStyle {
  func makeBody(configuration: Configuration) -> some View {
    Button {
      configuration.isOn.toggle()
    } label: {
      Label {
        configuration.label
      } icon: {
        Image(systemName: configuration.isOn ? "checkmark.circle.fill" : "circle")
          .foregroundStyle(configuration.isOn ? Color.accentColor : .secondary)
          .accessibility(label: Text(configuration.isOn ? "Checked" : "Unchecked"))
          .imageScale(.large)
      }
    }
    .buttonStyle(.plain)
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
