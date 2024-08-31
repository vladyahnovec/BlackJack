//
//  Item.swift
//  BJ
//
//  Created by Круглич Влад on 28.06.24.
//

import Foundation
import SwiftData

@Model
class Item: Identifiable {
    var id: UUID
    var timestamp: Date
    var bank : String
    init(timestamp: Date, bank: String) {
        self.id = UUID()
        self.timestamp = timestamp
        self.bank = bank
    }
}
