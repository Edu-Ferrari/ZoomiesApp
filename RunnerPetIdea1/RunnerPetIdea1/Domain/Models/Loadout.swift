//
//  Loadout.swift
//  RunnerPetIdea1
//
//  Created by Eduardo Ferrari on 02/09/25.
//

import SwiftData

@Model
final class Loadout {
    @Attribute(.unique) var id: String
    var hatId: String?
    var suitId: String?
    var trailId: String?

    init(id: String = "active", hatId: String? = nil, suitId: String? = nil, trailId: String? = nil) {
        self.id = id
        self.hatId = hatId
        self.suitId = suitId
        self.trailId = trailId
    }
}
