//
//  OwnedItem.swift
//  RunnerPetIdea1
//
//  Created by Eduardo Ferrari on 02/09/25.
//

import Foundation
import SwiftData

@Model
final class OwnedItem {
    @Attribute(.unique) var itemId: String
    var type: String
    var rarity: String
    var isEquipped: Bool
    var assetName: String
    var acquiredAt: Date

    init(itemId: String, type: String, rarity: String, assetName: String, isEquipped: Bool = false) {
        self.itemId = itemId
        self.type = type
        self.rarity = rarity
        self.assetName = assetName
        self.isEquipped = isEquipped
        self.acquiredAt = .now
    }
}
