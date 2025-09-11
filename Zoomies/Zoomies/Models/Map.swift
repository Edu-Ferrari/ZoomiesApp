//
//  Zoomie.swift
//  Zoomies
//
//  Created by Guilherme Ghise Rossoni on 08/09/25.
//

import Foundation
import SwiftData

/// Um mapa composto por múltiplos checkpoints.
@Model
public class Map {
    /// Identificador estável. `@Attribute(.unique)` garante unicidade no store.
    @Attribute(.unique) public var id = UUID()
    /// Nome exibido em UI (usado para ordenação simples no `@Query`).
    var name: String
    /// Checkpoints associados a este mapa.
    var checkpoints : [Checkpoint]

    public init(name: String, checkpoints: [Checkpoint]) {
        self.name = name
        self.checkpoints = checkpoints
    }
}
