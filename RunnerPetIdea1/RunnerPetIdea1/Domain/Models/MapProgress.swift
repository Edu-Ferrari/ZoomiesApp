//
//  MapProgress.swift
//  RunnerPetIdea1
//
//  Created by Eduardo Ferrari on 02/09/25.
//

import SwiftData

@Model
final class MapProgress {
    @Attribute(.unique) var id: String
    var mapId: String
    var totalKmAllTime: Double
    var mapKmAccumulated: Double
    var dotIndex: Int

    init(mapId: String, totalKmAllTime: Double = 0, mapKmAccumulated: Double = 0, dotIndex: Int = 0) {
        self.id = "progress_\(mapId)"
        self.mapId = mapId
        self.totalKmAllTime = totalKmAllTime
        self.mapKmAccumulated = mapKmAccumulated
        self.dotIndex = dotIndex
    }
}
