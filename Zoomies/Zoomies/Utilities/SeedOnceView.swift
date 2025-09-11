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
                // Não reinsere se já existir ao menos um mapa.
                guard existingMaps.isEmpty else { return }

                // Checkpoints de exemplo (10 níveis decrescentes por distância alvo).
                let cps: [Checkpoint] = [
                    .init(level: 1,  chests: [], distance: 1900, isUnlocked: false, rewardClaimed: false, mapId: 1),
                    .init(level: 2,  chests: [], distance: 1700, isUnlocked: false, rewardClaimed: false, mapId: 1),
                    .init(level: 3,  chests: [], distance: 1500, isUnlocked: false, rewardClaimed: false, mapId: 1),
                    .init(level: 4,  chests: [], distance: 1300, isUnlocked: false, rewardClaimed: false, mapId: 1),
                    .init(level: 5,  chests: [], distance: 1100, isUnlocked: false, rewardClaimed: false, mapId: 1),
                    .init(level: 6,  chests: [], distance:  900, isUnlocked: false, rewardClaimed: false, mapId: 1),
                    .init(level: 7,  chests: [], distance:  700, isUnlocked: false, rewardClaimed: false, mapId: 1),
                    .init(level: 8,  chests: [], distance:  500, isUnlocked: false, rewardClaimed: false, mapId: 1),
                    .init(level: 9,  chests: [], distance:  300, isUnlocked: false, rewardClaimed: false, mapId: 1),
                    .init(level: 10, chests: [], distance:  100, isUnlocked: false, rewardClaimed: false, mapId: 1)
                ]
                let map = Map(name: "Mapa 1", checkpoints: cps)
                context.insert(map)
                try? context.save()
            }
    }
}
