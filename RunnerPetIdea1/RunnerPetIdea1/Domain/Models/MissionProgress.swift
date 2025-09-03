//
//  MissionProgress.swift
//  RunnerPetIdea1
//
//  Created by Eduardo Ferrari on 02/09/25.
//

import Foundation
import SwiftData

@Model
final class MissionProgress {
    @Attribute(.unique) var id: String // missionId + periodKey
    var missionId: String
    var period: String // daily | weekly | monthly
    var periodKey: String
    var targetKm: Double
    var currentKm: Double
    var isCompleted: Bool
    var claimedAt: Date?

    init(missionId: String, period: String, periodKey: String, targetKm: Double) {
        self.id = "\(missionId)_\(periodKey)"
        self.missionId = missionId
        self.period = period
        self.periodKey = periodKey
        self.targetKm = targetKm
        self.currentKm = 0
        self.isCompleted = false
    }
}
