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
    @State private var definition = ""
    
    var addWord: (String, String) -> Void
    
    var body: some View {
      NavigationView {
        Form {
          Section(header: Text("New Word")) {
            TextField("Word", text: $word).textInputAutocapitalization(.never)
            TextField("Definition", text: $definition)
          }
            
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
}
