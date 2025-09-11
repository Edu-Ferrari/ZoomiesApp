//
//  Zoomie.swift
//  Zoomies
//
//  Created by Guilherme Ghise Rossoni on 08/09/25.
// MapView.swift
// Tela do mapa: exibe trilha de progresso, checkpoints e o "player".

import SwiftUI
import SwiftData

struct MapView: View {
    @StateObject private var vm = MapViewController()
    private let colorProgressFill = Color("progressFill")

    // Busca o 1º mapa do banco
    @Query(sort: \Map.name) private var maps: [Map]

    private let playerDistanceStart: Double = 0

    var body: some View {
        ZStack {
            // Imagem de fundo do mapa (deve existir no Assets)
            Image("backgroundMap")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            GeometryReader { geo in
                let size = geo.size

                ZStack {
                    // Linha de progresso
                    vm.progressPath()
                        .stroke(
                            colorProgressFill,
                            style: .init(lineWidth: 20, lineCap: .round, lineJoin: .round)
                        )

                    // Checkpoints SEMPRE visíveis
                    ForEach(vm.checkpointsRender()) { rcp in
                        let pos = vm.pointAt(rcp.t)
                        CheckpointDot(
                            level: rcp.levelDisplay,
                            reached: rcp.isUnlocked,
                            selected: rcp.isSelected,
                            isUnlocked: rcp.isUnlocked,
                            showHaloWhenReached: true,
                            style: .init(
                                baseSize: 44,
                                colorLocked: Color("checkpointLocked"),
                                colorUnlocked: Color("checkpointUnlocked"),
                                background: .white,
                                borderWidth: 5
                            )
                        )
                        .position(pos)
                    }

                    // Player (segue o progresso)
                    Circle()
                        .fill(Color.red)
                        .frame(width: 24, height: 24)
                        .shadow(radius: 3, y: 2)
                        .position(vm.pointAt(vm.progresso))
                        .animation(.spring(response: 0.28, dampingFraction: 0.7), value: vm.progresso)
                }
                .onAppear {
                    vm.updateGeometry(for: size)
                    vm.configure(map: maps.first, playerDistance: playerDistanceStart)
                }
                .onChange(of: size) { vm.updateGeometry(for: $0) }
                .onChange(of: maps) { _, new in
                    vm.configure(map: new.first, playerDistance: vm.playerDistance)
                }
            }
        }
        // Slider de debug para simular avanço (desativar em produção)
        .safeAreaInset(edge: .bottom) {
            HStack {
                Slider(value: $vm.progresso, in: 0...1, step: 0.001)
                    .onChange(of: vm.progresso) { _ in vm.syncPlayerDistanceFromProgress() }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
        }
        .zIndex(1)
    }
}

#Preview {
    MapView()
        .modelContainer(for: [Map.self, Checkpoint.self, Chest.self], inMemory: true)
}
