//
//  Zoomie.swift
//  Zoomies
//
//  Created by Guilherme Ghise Rossoni on 08/09/25.
//

import Foundation
import SwiftData

@Model
public class User {
    @Attribute(.unique) public var id = UUID()
    var gems: Int
    var coins: Int
    var distTravelled: Double
    
    init(gems: Int, coins: Int, distTravelled: Double) {
        self.gems = gems
        self.coins = coins
        self.distTravelled = distTravelled
    }
}
