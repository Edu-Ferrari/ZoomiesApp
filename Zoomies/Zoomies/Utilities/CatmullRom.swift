// CatmullRom.swift
// Utilitários para amostragem de curvas Catmull–Rom (trilha suave do mapa).

import SwiftUI

public enum CatmullRom {
    /// Retorna pontos amostrados ao longo de uma curva Catmull–Rom que passa pelos `points`.
    /// - Parameters:
    ///   - points: Waypoints originais (mín. 2). Para suavização,
    ///             o método adiciona cópias refletidas nas extremidades.
    ///   - samples: Quantidade total aproximada de amostras.
    ///   - tension: 0 (centrípeta padrão) a 1 (segmentos mais retos).
    static func samples(through points: [CGPoint], samples: Int, tension: CGFloat = 0.5) -> [CGPoint] {
        guard points.count >= 2 else { return points }
        var pts = points
        let p0 = points.first!
        let p1 = points[1]
        let pn = points[points.count - 1]
        let pn1 = points[points.count - 2]
        // Pontos fantasmas nas extremidades para continuidade da tangente
        pts.insert(CGPoint(x: 2*p0.x - p1.x, y: 2*p0.y - p1.y), at: 0)
        pts.append(CGPoint(x: 2*pn.x - pn1.x, y: 2*pn.y - pn1.y))

        var out: [CGPoint] = []
        let segs = points.count - 1
        let perSeg = max(2, samples / max(1, segs))

        for i in 0..<(pts.count - 3) {
            let p0 = pts[i], p1 = pts[i+1], p2 = pts[i+2], p3 = pts[i+3]
            for j in 0..<perSeg {
                let t = CGFloat(j) / CGFloat(perSeg)
                out.append(catmullPoint(t: t, p0: p0, p1: p1, p2: p2, p3: p3, tension: tension))
            }
        }
        out.append(points.last!)
        return out
    }

    /// Ponto na curva para parâmetro `t` ∈ [0,1] entre p1 e p2.
    private static func catmullPoint(t: CGFloat, p0: CGPoint, p1: CGPoint, p2: CGPoint, p3: CGPoint, tension: CGFloat) -> CGPoint {
        let c = (1 - tension) / 2
        let t2 = t * t
        let t3 = t2 * t

        let a0 = -c*t3 + 2*c*t2 - c*t
        let a1 = (2 - c)*t3 + (c - 3)*t2 + 1
        let a2 = (c - 2)*t3 + (3 - 2*c)*t2 + c*t
        let a3 = c*t3 - c*t2

        let x = a0*p0.x + a1*p1.x + a2*p2.x + a3*p3.x
        let y = a0*p0.y + a1*p1.y + a2*p2.y + a3*p3.y
        return CGPoint(x: x, y: y)
    }

    /// Soma cumulativa das distâncias entre amostras sucessivas.
    static func cumulativeLengths(_ pts: [CGPoint]) -> [CGFloat] {
        guard !pts.isEmpty else { return [] }
        var cum: [CGFloat] = [0]
        var acc: CGFloat = 0
        for i in 1..<pts.count {
            acc += hypot(pts[i].x - pts[i-1].x, pts[i].y - pts[i-1].y)
            cum.append(acc)
        }
        return cum
    }

    /// Retorna o ponto na curva para um comprimento alvo em `[0, total]`.
    static func point(at length: CGFloat, samples: [CGPoint], cumulative: [CGFloat]) -> CGPoint {
        guard !samples.isEmpty, samples.count == cumulative.count else { return .zero }
        let L = max(0, min(length, cumulative.last ?? 0))
        let idx = indexFor(length: L, cumulative: cumulative)
        if idx >= samples.count - 1 { return samples.last! }
        let l0 = cumulative[idx], l1 = cumulative[idx + 1]
        let frac = (L - l0) / max(1e-6, (l1 - l0))
        return lerp(samples[idx], samples[idx + 1], frac)
    }

    /// Busca binária do índice tal que `cumulative[idx] <= length`.
    static func indexFor(length: CGFloat, cumulative: [CGFloat]) -> Int {
        var lo = 0, hi = cumulative.count - 1, ans = 0
        while lo <= hi {
            let mid = (lo + hi) / 2
            if cumulative[mid] <= length { ans = mid; lo = mid + 1 }
            else { hi = mid - 1 }
        }
        return ans
    }

    /// Interpolação linear entre dois pontos.
    static func lerp(_ a: CGPoint, _ b: CGPoint, _ t: CGFloat) -> CGPoint {
        CGPoint(x: a.x + (b.x - a.x) * t, y: a.y + (b.y - a.y) * t)
    }
}
