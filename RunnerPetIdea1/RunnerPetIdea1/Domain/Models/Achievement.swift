//
//  Achievement.swift
//  RunnerPetIdea1
//
//  Created by Eduardo Ferrari on 02/09/25.
//

import SwiftData
import Foundation

@Model
final class Achievement {
    @Attribute(.unique) var id: String
    var title: String
    var achievedAt: Date
    
    init(id: String, title: String, achievedAt: Date) {
        self.id = id
        self.title = title
        self.achievedAt = achievedAt
    }
}
