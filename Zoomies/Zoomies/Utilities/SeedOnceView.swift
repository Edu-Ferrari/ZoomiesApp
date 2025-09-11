//
//  Zoomie.swift
//  Zoomies
//
//  Created by Guilherme Ghise Rossoni on 08/09/25.
//
// SeedOnceView.swift
// Wrapper que, na primeira execução, semeia um `Map` pré-configurado no store.

import SwiftUI
import SwiftData

/// Envolve um conteúdo e semeia dados no container na primeira execução.
struct SeedOnceView<Content: View>: View {
    @Environment(\.modelContext) private var context
    @Query private var existingMaps: [Map]

    let content: Content
    init(@ViewBuilder content: () -> Content) { self.content = content() }

    var body: some View {
        content
            .task {
                /// Não reinsere se já existir ao menos um mapa.
                guard existingMaps.isEmpty else { return }

                /// Checkpoints de exemplo (10 níveis)
                let stepsPerLevel = 250.0
                let levels = 10
                let cps: [Checkpoint] = (1...levels).map { level in
                    .init(
                        level: level,
                        chests: [],
                        distance: Double(level) * stepsPerLevel,
                        isUnlocked: false,
                        rewardClaimed: false,
                        mapId: 1
                    )
                }
                let map = Map(name: "Mapa 1", checkpoints: cps)
                context.insert(map)
                try? context.save()
            
            }
    }
}
