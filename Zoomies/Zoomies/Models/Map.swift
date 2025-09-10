//
//  Zoomie.swift
//  Zoomies
//
//  Created by Guilherme Ghise Rossoni on 08/09/25.
//

import Foundation

public struct Map {
    var id = UUID()
    var name: String
    var checkpoints : [Checkpoint]
    
    public init(name: String, checkpoints: [Checkpoint]) {
            self.name = name
            self.checkpoints = checkpoints
        }
}

/// Identidade estável para ForEach sem precisar alterar teus models
public extension Checkpoint {
    var composedId: Int { mapId &* 10_000 &+ level }
}
