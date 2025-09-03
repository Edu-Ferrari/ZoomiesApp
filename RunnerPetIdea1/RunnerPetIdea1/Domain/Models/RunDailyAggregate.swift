//
//  RunDailyAggregate.swift
//  RunnerPetIdea1
//
//  Created by Eduardo Ferrari on 02/09/25.
//

import Foundation
import SwiftData

@Model
final class RunDailyAggregate {
    @Attribute(.unique) var dayKey: String // yyyy-MM-dd
    var dayStart: Date
    var steps: Int
    var distanceMeters: Double
    var energyKcal: Double

    init(dayStart: Date, steps: Int = 0, distanceMeters: Double = 0, energyKcal: Double = 0) {
        self.dayStart = dayStart
        self.dayKey = Self.key(from: dayStart)
        self.steps = steps
        self.distanceMeters = distanceMeters
        self.energyKcal = energyKcal
    }

    static func key(from date: Date) -> String {
        let f = DateFormatter()
        f.calendar = .current
        f.dateFormat = "yyyy-MM-dd"
        return f.string(from: Calendar.current.startOfDay(for: date))
    }
}
