////
////  Zoomie.swift
////  Zoomies
////
////  Created by Guilherme Ghise Rossoni on 08/09/25.
////
//
import Foundation
import SwiftData


public enum MissionKind: String, Codable {
    case tier = "tier"
    case noTier = "noTier"
}

public enum MissionFrequency: String, Codable {
    case daily = "daily"
    case weekly = "weekly"
    case monthly = "monthly"
    case yearly = "yearly"
    case unlimited = "unlimited"
}

@Model
public class Mission {
    @Attribute(.unique) public var id: UUID
    var name: String
    var details: String
    var startTime: Date?
    var endTime: Date?
    var metric: String
    var unit: String
    var kind: MissionKind
    var frequency: MissionFrequency

    // Campos exclusivos de missões tier
    var targetTier1: Int?
    var targetTier2: Int?
    var targetTier3: Int?
    var reward1: Int?
    var reward2: Int?
    var reward3: Int?
    var emblem1: Emblem?
    var emblem2: Emblem?
    var emblem3: Emblem?

    // Campos exclusivos de missão sem tier
    var target: String?
    var reward: Int?
    var emblem: Emblem?

    init(
        id: UUID = UUID(),
        name: String,
        details: String,
        startTime: Date? = nil,
        endTime: Date? = nil,
        metric: String,
        unit: String,
        kind: MissionKind,
        frequency: MissionFrequency
    ) {
        self.id = id
        self.name = name
        self.details = details
        self.startTime = startTime
        self.endTime = endTime
        self.metric = metric
        self.unit = unit
        self.kind = kind
        self.frequency = frequency
    }
}
