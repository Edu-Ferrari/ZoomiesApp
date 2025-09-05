//
//  Zoomie.swift
//  ZoomiesApp
//
//  Created by Guilherme Ghise Rossoni on 05/09/25.
//

import Foundation
import SwiftData

@Model
final class Zoomie {
    @Attribute(.unique) var zoomieId: String
    var owner: User?
    var displayName: String
    var createdAt: Date
    var updatedAt: Date
    var energy: Int
    
    init(zoomieId: String, owner: User? = nil, displayName: String, createdAt: Date, updatedAt: Date, energy: Int) {
        self.zoomieId = zoomieId
        self.owner = owner
        self.displayName = displayName
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.energy = energy
    }
    
}
