//
//  Item.swift
//  Verbalix
//
//  Created by Alex Beals on 8/20/24.
//

import Foundation
import SwiftData

@Model
final class Word {
  var word: String
  var definitions: Set<String>
  var dateAdded: Date
    
  init(word: String, definitions: Set<String>, dateAdded: Date) {
    self.word = word
    self.definitions = definitions
    self.dateAdded = dateAdded
  }
}
