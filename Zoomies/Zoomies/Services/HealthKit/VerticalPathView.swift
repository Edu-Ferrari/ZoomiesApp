//
//  VerticalPathView.swift
//  Zoomies
//
//  Created by Eduardo Ferrari on 11/09/25.
//

import SwiftUI

struct VerticalPathView: View {
    var stepsToday: Int

    // Progresso atual baseado nos passos
    var targetProgress: CGFloat {
        min(CGFloat(stepsToday) / 1000.0, 1.0)
    }

    @State private var animatedProgress: CGFloat = 0.0
    @State private var checkpointScales: [CGFloat] = Array(repeating: 1.0, count: 10)

    // Para garantir que só anima 1x por atualização
    @State private var hasAnimated = false

    let checkpoints: [CGFloat] = [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0]
    private let savedStepsKey = "lastAnimatedSteps"

    var body: some View {
        VStack {
            ZStack {
                // Caminho base
                path()
                    .stroke(Color.gray.opacity(0.3), lineWidth: 16)

                // Caminho preenchido
                path()
                    .trim(from: 0, to: animatedProgress)
                    .stroke(Color.blue, style: StrokeStyle(lineWidth: 16, lineCap: .round))

                // Checkpoints
                ForEach(checkpoints.indices, id: \.self) { i in
                    let t = checkpoints[i]
                    Circle()
                        .fill(t <= animatedProgress ? Color.green : Color.white)
                        .frame(width: 24 * checkpointScales[i], height: 24 * checkpointScales[i])
                        .position(positionAlongCurve(t: t))
                        .shadow(radius: 2)
                        .animation(.spring(), value: checkpointScales[i])
                }

                // Bolinha vermelha animada
                Circle()
                    .fill(Color.red)
                    .frame(width: 24, height: 24)
                    .position(positionAlongCurve(t: animatedProgress))
                    .animation(.easeInOut(duration: 0.8), value: animatedProgress)
            }
            .frame(height: 700)
            .padding()
        }
        // Monitorar quando `stepsToday` chega do HealthKit
        .onChange(of: stepsToday) { _, _ in
            triggerAnimationIfNeeded()
        }
        .onAppear {
            triggerAnimationIfNeeded()
        }
    }

    /// Chama animação só se necessário
    func triggerAnimationIfNeeded() {
        guard stepsToday > 0, !hasAnimated else { return }

        let lastAnimatedSteps = UserDefaults.standard.integer(forKey: savedStepsKey)

        if lastAnimatedSteps == 0 {
            // Primeira vez no app → anima do início
            animatedProgress = 0
            animateProgress(to: targetProgress, fromSteps: 0)
        } else if stepsToday > lastAnimatedSteps {
            // Usuário andou mais → anima do ponto anterior
            let from = min(CGFloat(lastAnimatedSteps) / 1000.0, 1.0)
            animatedProgress = from
            animateProgress(to: targetProgress, fromSteps: lastAnimatedSteps)
        } else {
            // Nenhuma mudança → mostra direto
            animatedProgress = targetProgress
        }

        hasAnimated = true
    }

    /// Anima bolinha e checkpoints
    func animateProgress(to newValue: CGFloat, fromSteps: Int) {
        let from = min(CGFloat(fromSteps) / 1000.0, 1.0)
        let totalSteps = Int((newValue - from) * 1000)
        let steps = max(1, totalSteps / 10)
        var current = from

        Timer.scheduledTimer(withTimeInterval: 0.06, repeats: true) { timer in
            current += CGFloat(steps) / 1000.0
            if current >= newValue {
                animatedProgress = newValue
                timer.invalidate()
                // Salva o novo valor de passos
                UserDefaults.standard.set(stepsToday, forKey: savedStepsKey)
                return
            }
            animatedProgress = current

            for (i, t) in checkpoints.enumerated() {
                if abs(current - t) < 0.03 {
                    checkpointScales[i] = 1.4
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                        checkpointScales[i] = 1.0
                    }
                }
            }
        }
    }

    func path() -> Path {
        Path { path in
            path.move(to: CGPoint(x: 200, y: 50))
            path.addCurve(to: CGPoint(x: 200, y: 650),
                          control1: CGPoint(x: 50, y: 200),
                          control2: CGPoint(x: 350, y: 500))
        }
    }

    func positionAlongCurve(t: CGFloat) -> CGPoint {
        let p0 = CGPoint(x: 200, y: 50)
        let p1 = CGPoint(x: 50, y: 200)
        let p2 = CGPoint(x: 350, y: 500)
        let p3 = CGPoint(x: 200, y: 650)

        let x = cubicBezier(t: t, p0: p0.x, p1: p1.x, p2: p2.x, p3: p3.x)
        let y = cubicBezier(t: t, p0: p0.y, p1: p1.y, p2: p2.y, p3: p3.y)
        return CGPoint(x: x, y: y)
    }

    func cubicBezier(t: CGFloat, p0: CGFloat, p1: CGFloat, p2: CGFloat, p3: CGFloat) -> CGFloat {
        let mt = 1 - t
        return mt*mt*mt*p0 + 3*mt*mt*t*p1 + 3*mt*t*t*p2 + t*t*t*p3
    }
}
