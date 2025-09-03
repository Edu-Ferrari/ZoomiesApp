//
//  MapEngine.swift
//  RunnerPetIdea1
//
//  Created by Eduardo Ferrari on 02/09/25.
//


struct MapEngine {
    func advance(progress: MapProgress, with newDistanceKm: Double, targets: [Double]) -> MapProgress {
        var p = progress
        p.totalKmAllTime += newDistanceKm
        p.mapKmAccumulated += newDistanceKm
        while p.dotIndex < min(9, targets.count - 1) && p.mapKmAccumulated >= targets[p.dotIndex] {
            p.dotIndex += 1
        }
        return p
    }
}
