//
//  MissionEngine.swift
//  RunnerPetIdea1
//
//  Created by Eduardo Ferrari on 02/09/25.
//

import Foundation
import SwiftData

struct MissionEngine {
    func ensureDailyMissions(for date: Date, ctx: ModelContext) {
        // Example: create a simple daily distance mission 2km if not exists
        let key = dayKey(date)
        let id = "daily_distance_2km_\(key)"
        let fetch = FetchDescriptor<MissionProgress>(predicate: #Predicate { $0.id == id })
        if let has = try? ctx.fetch(fetch), !has.isEmpty { return }
        let m = MissionProgress(missionId: "daily_distance_2km", period: "daily", periodKey: key, targetKm: 2.0)
        ctx.insert(m)
        try? ctx.save()
    }

    func registerDistance(_ km: Double, ctx: ModelContext) {
        // Increment all active daily missions for today
        let key = dayKey(Date())
        let fetch = FetchDescriptor<MissionProgress>(predicate: #Predicate { $0.period == "daily" && $0.periodKey == key })
        if let missions = try? ctx.fetch(fetch) {
            for m in missions {
                m.currentKm += km
                if !m.isCompleted && m.currentKm >= m.targetKm { m.isCompleted = true }
            }
            try? ctx.save()
        }
    }

    private func dayKey(_ date: Date) -> String {
        let f = DateFormatter(); f.calendar = .current; f.dateFormat = "yyyy-MM-dd"
        return f.string(from: Calendar.current.startOfDay(for: date))
    }
}
