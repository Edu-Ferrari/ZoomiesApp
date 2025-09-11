//
//  Mission.swift
//  Zoomies
//
//  Created by Gabriel Barbosa on 11/09/25.
//

import Foundation
import SwiftData

@Model
class Mission: Identifiable {
    var id: UUID = UUID()
    var name: String
    var details: String
    var metric: String
    var progress: Double
    var goal: Double
    var startDate: Date?
    var endDate: Date?
    var coinReward: Int
    var gemReward: Int
    var emblem: Emblem?
    var rewardClaimed: Bool = false
    var wasCompleted: Bool = false
    
    init(name: String, details: String, metric: String, progress: Double, goal: Double, startDate: Date? = nil, endDate: Date? = nil, coinReward: Int, gemReward: Int, emblem: Emblem? = nil) {
        self.name = name
        self.details = details
        self.metric = metric
        self.progress = progress
        self.goal = goal
        self.startDate = startDate
        self.endDate = endDate
        self.coinReward = coinReward
        self.gemReward = gemReward
        self.emblem = emblem
    }
}
