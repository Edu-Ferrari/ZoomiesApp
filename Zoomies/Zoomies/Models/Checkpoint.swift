//
//  Zoomie.swift
//  Zoomies
//
//  Created by Guilherme Ghise Rossoni on 08/09/25.
//

import Foundation

public struct Checkpoint {
    var level : Int
    var chests : [Chest]
    var distance : Double
    var isUnlocked : Bool
    var rewardClaimed : Bool
    var mapId : Int
    
    public init(level: Int, chests: [Chest], distance: Double, isUnlocked: Bool, rewardClaimed: Bool, mapId: Int) {
        self.level = level
        self.chests = chests
        self.distance = distance
        self.isUnlocked = isUnlocked
        self.rewardClaimed = rewardClaimed
        self.mapId = mapId
    }
}
