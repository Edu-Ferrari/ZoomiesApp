//
//  Zoomie.swift
//  Zoomies
//
//  Created by Guilherme Ghise Rossoni on 08/09/25.
//

import Foundation
import SwiftData

/// Um checkpoint do mapa com distância-alvo e recompensas (baús).
@Model
public class Checkpoint {
    /// Nível lógico (não é o índice visual; o MapView calcula a ordem exibida).
    var level : Int
    /// Baús vinculados ao checkpoint (pode estar vazio).
    var chests : [Chest]
    /// Distância total necessária (em metros) para considerar o checkpoint alcançado.
    var distance : Double
    /// Flag de desbloqueio lógico (ex.: por design).
    var isUnlocked : Bool
    /// Se a recompensa já foi resgatada após o desbloqueio.
    var rewardClaimed : Bool
    /// Relacionamento lógico com um mapa (pode ser usado para filtros/queries).
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
