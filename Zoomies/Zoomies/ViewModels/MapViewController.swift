//
//  Zoomie.swift
//  Zoomies
//
//  Created by Guilherme Ghise Rossoni on 08/09/25.
// ViewModel/Controlador do mapa. Concentra estado derivado, projeção de
// modelos para renderização, e utilitários de geometria da trilha.

import SwiftUI
import SwiftData

/// DTO imutável específico para a View (não manipula diretamente os `@Model`).
struct RenderCheckpoint: Identifiable {
    /// ID persistente do modelo `Checkpoint` (estável para ForEach/identidade).
    let id: PersistentIdentifier
    /// Número exibido no dot (1..N), calculado em ordem visual.
    let levelDisplay: Int
    /// Distância alvo deste checkpoint (m).
    let distance: Double
    /// Se está desbloqueado considerando a distância do jogador.
    let isUnlocked: Bool
    /// Se é o checkpoint “selecionado” (o mais próximo do progresso atual).
    let isSelected: Bool
    /// Parâmetro normalizado 0..1 ao longo da trilha para posicionamento.
    let t: CGFloat
}

/// Controlador de estado (ViewModel) do mapa.
final class MapViewController: ObservableObject {

    // MARK: Estado público observado pela View

    /// Progresso normalizado do jogador ao longo da trilha (0..1).
    @Published var progresso: CGFloat = 0.0
    /// Distância total percorrida pelo jogador (m). Fonte: HealthKit.
    @Published private(set) var playerDistance: Double = 0
    /// Mapa atual carregado do store.
    @Published private(set) var currentMap: Map? = nil

    // MARK: Geometria da trilha

    /// Waypoints normalizados (0..1) em coordenadas relativas da view.
    /// Ajuste estes pontos para mudar o desenho da trilha no mapa.
    private let wpN: [CGPoint] = [
        CGPoint(x: 0.80, y: 1.07),
        CGPoint(x: 0.83, y: 0.85),
        CGPoint(x: 0.35, y: 0.55),
        CGPoint(x: 0.80, y: 0.50),
        CGPoint(x: 0.50, y: 0.20),
        CGPoint(x: 0.80, y: 0.08)
    ]

    private var sampled: [CGPoint] = []
    private var cumul: [CGFloat] = []
    private var totalLen: CGFloat = 1
    private let samplesCount = 200
    private let tension: CGFloat = 0.0

    // MARK: Ciclo/configuração

    /// Define o mapa e atualiza a distância do jogador.
    /// - Note: Distância pode vir de HealthKit e ser acumulada/normalizada aqui.
    func configure(map: Map?, playerDistance: Double) {
        self.currentMap = map
        updatePlayerDistance(playerDistance)
    }

    /// Distância total do mapa baseada no maior `distance` dos checkpoints.
    var totalMapDistance: Double {
        guard let map = currentMap else { return 1.0 }
        let sorted = map.checkpoints.sorted { $0.distance < $1.distance }
        return sorted.last?.distance ?? 1.0
    }

    /// Projeta os modelos (`Checkpoint`) em `RenderCheckpoint` para a View.
    /// Também calcula qual é o dot selecionado com base no `progresso` atual.
    func checkpointsRender() -> [RenderCheckpoint] {
        guard let map = currentMap else { return [] }
        let sorted = map.checkpoints.sorted { $0.distance < $1.distance }

        // Índice do checkpoint mais próximo do `progresso`.
        let selectedIdx: Int? = {
            guard !sorted.isEmpty else { return nil }
            let ts = sorted.map { t(forDistance: $0.distance) }
            return ts.enumerated().min(by: { abs($0.element - progresso) < abs($1.element - progresso) })?.offset
        }()

        return sorted.enumerated().map { (idx, cp) in
            let tVal = t(forDistance: cp.distance)
            return RenderCheckpoint(
                id: cp.persistentModelID,
                levelDisplay: idx + 1,
                distance: cp.distance,
                isUnlocked: playerDistance + 0.0001 >= cp.distance,
                isSelected: selectedIdx == idx,
                t: tVal
            )
        }
    }

    /// Atualiza a distância do jogador e rederiva o `progresso` (0..1).
    func updatePlayerDistance(_ distance: Double) {
        playerDistance = max(0, distance)
        let denom = max(0.000_001, totalMapDistance)
        let p = CGFloat(min(max(playerDistance / denom, 0), 1))
        if abs(p - progresso) > 0.0001 { progresso = p }
    }

    /// Mantém `playerDistance` coerente quando o slider altera `progresso`.
    func syncPlayerDistanceFromProgress() {
        let newDistance = Double(progresso) * totalMapDistance
        if abs(newDistance - playerDistance) > 0.0001 {
            playerDistance = newDistance
        }
    }

    /// Conversão de distância absoluta (m) para parâmetro normalizado 0..1.
    func t(forDistance distance: Double) -> CGFloat {
        let denom = max(0.000_001, totalMapDistance)
        return CGFloat(min(max(distance / denom, 0), 1))
    }

    // MARK: Geometria/Paths

    /// Reamostra a trilha para o `size` atual da view.
    func updateGeometry(for size: CGSize) {
        let waypoints = wpN.map { CGPoint(x: $0.x * size.width, y: $0.y * size.height) }
        sampled = CatmullRom.samples(through: waypoints, samples: samplesCount, tension: tension)
        cumul = CatmullRom.cumulativeLengths(sampled)
        totalLen = cumul.last ?? 1
    }

    /// Ponto da trilha no parâmetro `t` (0..1).
    func pointAt(_ t: CGFloat) -> CGPoint {
        guard totalLen > 0 else { return .zero }
        let clamped = max(0, min(1, t))
        return CatmullRom.point(at: clamped * totalLen, samples: sampled, cumulative: cumul)
    }

    /// Path base da trilha completa (sem cor de progresso).
    func basePath() -> Path {
        Path { p in
            guard let first = sampled.first else { return }
            p.move(to: first)
            for pt in sampled.dropFirst() { p.addLine(to: pt) }
        }
    }

    /// Path parcial da trilha até o `progresso` atual.
    func progressPath() -> Path {
        Path { p in
            guard !sampled.isEmpty, !cumul.isEmpty else { return }
            let target = progresso * totalLen

            var i = CatmullRom.indexFor(length: target, cumulative: cumul)
            i = max(1, min(i, sampled.count - 1))

            p.move(to: sampled[0])
            for idx in 1...i { p.addLine(to: sampled[idx]) }

            if i < sampled.count - 1 {
                let l0 = cumul[i], l1 = cumul[i+1]
                let frac = (target - l0) / max(1e-6, (l1 - l0))
                let interp = CatmullRom.lerp(sampled[i], sampled[i+1], frac)
                p.addLine(to: interp)
            }
        }
        
        
    }
    
    
}
