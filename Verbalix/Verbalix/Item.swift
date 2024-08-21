//
//  Item.swift
//  Verbalix
//
//  Created by Alex Beals on 8/20/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
