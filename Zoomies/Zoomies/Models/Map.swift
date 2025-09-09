//
//  Zoomie.swift
//  Zoomies
//
//  Created by Guilherme Ghise Rossoni on 08/09/25.
//

import Foundation
import SwiftData

@Model
public class Map {
    public var id: Int
    var name: String
    var checkpoints : [Checkpoint]
    
    init(id: Int, name: String, checkpoints: [Checkpoint]) {
        self.id = id
        self.name = name
        self.checkpoints = checkpoints
    }
}
