//
//  MapViewController.swift
//  Zoomies
//
//  Created by Guilherme Ghise Rossoni on 08/09/25.
//

import SwiftUI

/// Controlador de estado (ViewModel) do mapa.
/// Responsável por:
/// - Calcular a geometria da estrada (amostragem da Catmull-Rom)
/// - Expor o progresso normalizado (0...1)
/// - Sincronizar distância do jogador com o progresso
/// - Mapear `Checkpoint` do domínio para níveis 1..N e estado de desbloqueio
final class MapViewController: ObservableObject {

    // MARK: - Estado público observado pela View

    /// Progresso do caminho (0...1). A View desenha o "trail" a partir disso.
    @Published var progresso: CGFloat = 0.0

    /// Distância atual do jogador ao longo do mapa (mesma unidade dos checkpoints).
    @Published private(set) var playerDistance: Double = 0

    /// Mapa atual (contém os checkpoints do domínio).
    @Published private(set) var currentMap: Map? = nil

    // MARK: - Waypoints (forma da estrada)

    /// Waypoints normalizados (0...1) que definem a spline da estrada.
    /// Esses pontos são dimensionados pelo tamanho da tela em `updateGeometry`.
    private let wpN: [CGPoint] = [
        CGPoint(x: 0.80, y: 1.07),
        CGPoint(x: 0.83, y: 0.85),
        CGPoint(x: 0.35, y: 0.55),
        CGPoint(x: 0.80, y: 0.50),
        CGPoint(x: 0.50, y: 0.20),
        CGPoint(x: 0.80, y: 0.08)
    ]

    // MARK: - Geometria amostrada (derivada)

    /// Amostras (pontos) da curva Catmull-Rom ao longo da estrada.
    private var sampled: [CGPoint] = []

    /// Comprimentos cumulativos entre amostras (auxilia buscas por comprimento).
    private var cumul: [CGFloat] = []

    /// Comprimento total da polilinha amostrada.
    private var totalLen: CGFloat = 1

    /// Quantidade de amostras para a curva (mais = curva mais suave + custo maior).
    private let samplesCount = 200

    /// Parâmetro de tensão da Catmull-Rom (0 = centrípeta padrão).
    private let tension: CGFloat = 0.0

    // MARK: - Projeções do domínio

    /// Checkpoints do domínio (ordenados por distância), com `level` normalizado 1..N
    /// e `isUnlocked` calculado com base em `playerDistance`.
    var checkpointsDomain: [Checkpoint] {
        guard let map = currentMap else { return [] }
        let sorted = map.checkpoints.sorted { $0.distance < $1.distance }
        return sorted.enumerated().map { idx, cp in
            var copy = cp
            // Normaliza o "level" para 1..N conforme a ordenação por distância
            copy.level = idx + 1
            // Desbloqueia se o jogador já alcançou essa distância
            if playerDistance + 0.0001 >= copy.distance {
                copy.isUnlocked = true
            }
            return copy
        }
    }

    /// Distância total considerada para o mapa (último checkpoint).
    var totalMapDistance: Double {
        checkpointsDomain.last?.distance ?? 1.0
    }

    // MARK: - Ciclo de configuração

    /// Define o mapa atual e sincroniza a distância inicial do jogador.
    /// - Parameters:
    ///   - map: Mapa com checkpoints (distâncias em ordem arbitrária).
    ///   - playerDistance: Distância inicial do jogador.
    func configure(map: Map, playerDistance: Double) {
        self.currentMap = map
        updatePlayerDistance(playerDistance)
    }

    // MARK: - Sincronização Progresso <-> Distância

    /// Atualiza a distância do jogador (>= 0) e recalcula `progresso` (0...1).
    /// Mantém `progresso` consistente mesmo se `totalMapDistance` mudar.
    func updatePlayerDistance(_ distance: Double) {
        playerDistance = max(0, distance)
        let denom = max(0.000_001, totalMapDistance)
        let p = CGFloat(min(max(playerDistance / denom, 0), 1))
        if abs(p - progresso) > 0.0001 { progresso = p }
    }

    /// Atualiza a distância do jogador a partir do `progresso` atual.
    /// Útil quando o usuário arrasta o slider de debug.
    func syncPlayerDistanceFromProgress() {
        let newDistance = Double(progresso) * totalMapDistance
        if abs(newDistance - playerDistance) > 0.0001 {
            playerDistance = newDistance
        }
    }

    // MARK: - Mapeamentos utilitários (domínio -> caminho)

    /// Retorna o parâmetro `t` (0...1) correspondente à distância do checkpoint no mapa.
    func t(for cp: Checkpoint) -> CGFloat {
        let denom = max(0.000_001, totalMapDistance)
        return CGFloat(min(max(cp.distance / denom, 0), 1))
    }

    /// Indica se o checkpoint já foi alcançado (com pequena tolerância numérica).
    func isCheckpointReached(_ cp: Checkpoint) -> Bool {
        playerDistance + 0.0001 >= cp.distance
    }

    /// Marca o checkpoint mais próximo do progresso atual como "selecionado".
    func isCheckpointSelected(_ cp: Checkpoint) -> Bool {
        guard let nearest = checkpointsDomain.min(by: {
            abs(t(for: $0) - progresso) < abs(t(for: $1) - progresso)
        }) else { return false }
        return nearest.level == cp.level && nearest.mapId == cp.mapId
    }

    // MARK: - Geometria / Spline

    /// Constrói a amostragem da curva baseado no tamanho da View.
    /// Deve ser chamado em `onAppear` e ao variar o `GeometryReader`.
    func updateGeometry(for size: CGSize) {
        let waypoints = wpN.map { CGPoint(x: $0.x * size.width, y: $0.y * size.height) }
        sampled = CatmullRom.samples(through: waypoints, samples: samplesCount, tension: tension)
        cumul = CatmullRom.cumulativeLengths(sampled)
        totalLen = cumul.last ?? 1
    }

    /// Posição no caminho para um parâmetro `t` (0...1).
    func pointAt(_ t: CGFloat) -> CGPoint {
        guard totalLen > 0 else { return .zero }
        let clamped = max(0, min(1, t))
        return CatmullRom.point(at: clamped * totalLen, samples: sampled, cumulative: cumul)
    }

    // MARK: - Paths para desenhar

    /// Caminho completo da estrada (polilinha amostrada).
    func basePath() -> Path {
        Path { p in
            guard let first = sampled.first else { return }
            p.move(to: first)
            for pt in sampled.dropFirst() { p.addLine(to: pt) }
        }
    }

    /// Caminho parcial representando o progresso atual (do início até `progresso`).
    func progressPath() -> Path {
        Path { p in
            guard !sampled.isEmpty, !cumul.isEmpty else { return }
            let target = progresso * totalLen

            var i = CatmullRom.indexFor(length: target, cumulative: cumul)
            i = max(1, min(i, sampled.count - 1))

            p.move(to: sampled[0])
            for idx in 1...i { p.addLine(to: sampled[idx]) }

            // Interpola o ponto fracionário entre i e i+1 (suaviza o término).
            if i < sampled.count - 1 {
                let l0 = cumul[i], l1 = cumul[i+1]
                let frac = (target - l0) / max(1e-6, (l1 - l0))
                let interp = CatmullRom.lerp(sampled[i], sampled[i+1], frac)
                p.addLine(to: interp)
            }
        }
    }
}

// MARK: - Preview
#Preview { TabBar() }
