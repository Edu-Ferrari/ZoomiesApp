//
//  MapView.swift
//  Zoomies
//
//  Created by Guilherme Ghise Rossoni on 08/09/25.
//

import SwiftUI

/// View principal que:
/// - Renderiza o background do mapa
/// - Desenha o progresso do trajeto (linha preenchida)
/// - Plota os checkpoints com nível, estado (locked/unlocked) e seleção
/// - Mostra o "player" sobre o caminho no ponto correspondente ao progresso
/// - Expõe um slider de debug para testar o progresso

struct MapView: View {
    // MARK: - Estado / ViewModel
    @StateObject private var vm = MapViewController()

    // MARK: - Paleta via Asset Catalog
    private let colorProgressFill = Color("progressFill")

    // MARK: - Dados do Mapa

    /// Mapa com 10 checkpoints (distâncias decrescentes no array)
    /// apenas para demonstrar que o `checkpointsDomain` ordena por distância).

    private var map1: Map {
        let checkpoints: [Checkpoint] = [
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
        return Map(name: "Mapa 1", checkpoints: checkpoints)
    }

    /// Distância inicial do jogador (0 = início da estrada).
    private let playerDistanceStart: Double = 0

    // MARK: - Body

    var body: some View {
        ZStack {
            /// Fundo do mapa (ilustração / tile do parque)
            Image("backgroundMap")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            GeometryReader { geo in
                let size = geo.size

                ZStack {
                    // MARK: - Progresso do caminho (camada "pintada" por cima da estrada)
                    vm.progressPath()
                        .stroke(
                            colorProgressFill,
                            style: .init(lineWidth: 20, lineCap: .round, lineJoin: .round)
                        )

                    // MARK: - Checkpoints (pinos/bolhas com nível)
                    ForEach(vm.checkpointsDomain, id: \.composedId) { cp in
                        let pos = vm.pointAt(vm.t(for: cp))

                        CheckpointDot(
                            level: cp.level,
                            reached: vm.isCheckpointReached(cp),
                            selected: vm.isCheckpointSelected(cp),
                            isUnlocked: cp.isUnlocked,
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

                    // MARK: - Player (ícone simples seguindo o progresso)
                    Circle()
                        .fill(Color(.red))
                        .frame(width: 24, height: 24)

                        .shadow(radius: 3, y: 2)
                        .position(vm.pointAt(vm.progresso))
                        /// Anima a movimentação quando o progresso muda (ex.: via slider)
                        .animation(.spring(response: 0.28, dampingFraction: 0.7), value: vm.progresso)
                }
                /// Marca a geometria assim que a View aparece e quando o size mudar
                .onAppear {
                    vm.updateGeometry(for: size)
                    vm.configure(map: map1, playerDistance: playerDistanceStart)
                }
                .onChange(of: size) { newSize in
                    vm.updateGeometry(for: newSize)
                }
            }
        }
        // MARK: - Controles de debug (slider de progresso)
        .safeAreaInset(edge: .bottom) {
            HStack {
                Slider(value: $vm.progresso, in: 0...1, step: 0.001)
                    .onChange(of: vm.progresso) { _ in
                        vm.syncPlayerDistanceFromProgress()
                    }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
        }
        .zIndex(1)
    }
}

// MARK: - Preview
#Preview { TabBar() }
