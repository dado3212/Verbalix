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
  var definition: String
  var dateAdded: Date
    
  init(word: String, definition: String, dateAdded: Date) {
    self.word = word
    self.definition = definition
    self.dateAdded = dateAdded
  }
}
