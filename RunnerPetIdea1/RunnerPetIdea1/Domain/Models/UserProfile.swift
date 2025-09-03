//
//  UserProfile.swift
//  RunnerPetIdea1
//
//  Created by Eduardo Ferrari on 02/09/25.
//

import Foundation
import SwiftData

@Model
final class UserProfile {
    @Attribute(.unique) var userId: String
    var displayName: String
    var gems: Int
    var currentMapId: String?
    var createdAt: Date
    var updatedAt: Date

    init(userId: String, displayName: String, gems: Int = 0, currentMapId: String? = nil) {
        self.userId = userId
        self.displayName = displayName
        self.gems = gems
        self.currentMapId = currentMapId
        self.createdAt = .now
        self.updatedAt = .now
    }
}
