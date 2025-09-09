//
//  Zoomie.swift
//  Zoomies
//
//  Created by Guilherme Ghise Rossoni on 08/09/25.
//

import Foundation

public struct User: Codable {
    var id = UUID()
    var gems: Int
    var coins: Int
    var distTravelled: Double
}
