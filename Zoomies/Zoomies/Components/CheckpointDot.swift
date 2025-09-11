// CheckpointDot.swift
// Componente visual reutilizável para um checkpoint (dot) do mapa.

import SwiftUI

/// Estilo visual de `CheckpointDot` (tamanhos/cores/borda).
public struct CheckpointDotStyle {
    public var baseSize: CGFloat
    public var colorLocked: Color
    public var colorUnlocked: Color
    public var background: Color
    public var borderWidth: CGFloat

    public init(
        baseSize: CGFloat = 44,
        colorLocked: Color = .gray,
        colorUnlocked: Color = .green,
        background: Color = .white,
        borderWidth: CGFloat = 3
    ) {
        self.baseSize = baseSize
        self.colorLocked = colorLocked
        self.colorUnlocked = colorUnlocked
        self.background = background
        self.borderWidth = borderWidth
    }
}

/// Bolinha de checkpoint numerada com estados de seleção e desbloqueio.
public struct CheckpointDot: View {
    /// Nível exibido dentro do dot (1..N)
    public let level: Int
    /// Indica se o usuário já alcançou fisicamente este ponto (distância).
    public let reached: Bool
    /// Indica se o dot está destacado (ex.: mais próximo ao progresso).
    public let selected: Bool
    /// Estado lógico vindo do domínio (permite diferenciar de `reached`).
    public let isUnlocked: Bool
    /// Mostra um halo (aura) quando `reached == true`.
    public let showHaloWhenReached: Bool
    /// Estilo visual (cores/tamanhos).
    public var style: CheckpointDotStyle

    public init(
        level: Int,
        reached: Bool,
        selected: Bool,
        isUnlocked: Bool,
        showHaloWhenReached: Bool = true,
        style: CheckpointDotStyle = .init()
    ) {
        self.level = level
        self.reached = reached
        self.selected = selected
        self.isUnlocked = isUnlocked
        self.showHaloWhenReached = showHaloWhenReached
        self.style = style
    }

    public var body: some View {
        let isActive = isUnlocked || reached
        let mainColor = isActive ? style.colorUnlocked : style.colorLocked
        let size = style.baseSize + (selected ? 10 : 0)
        let border = style.borderWidth + (selected ? 1 : 0)

        ZStack {
            // Disco base com borda de estado
            Circle()
                .fill(style.background)
                .overlay(
                    Circle().stroke(mainColor, lineWidth: border)
                )
                .frame(width: size, height: size)
                .shadow(radius: selected ? 5 : 2)

            // Número dentro da bolinha (sempre visível)
            Text("\(level)")
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundColor(mainColor)

            // Halo quando alcançado (opcional)
            if showHaloWhenReached && reached {
                Circle()
                    .stroke(mainColor.opacity(0.25), lineWidth: 8)
                    .frame(width: size + 10, height: size + 10)
                    .blur(radius: 0.5)
            }
        }
        .accessibilityLabel("Checkpoint nível \(level), \(isActive ? "desbloqueado" : "bloqueado")")
        .animation(.spring(response: 0.22, dampingFraction: 0.65), value: selected)
    }
}

#Preview("CheckpointDot - states") {
    VStack(spacing: 24) {
        CheckpointDot(level: 1, reached: false, selected: false, isUnlocked: false)
        CheckpointDot(level: 2, reached: true,  selected: false, isUnlocked: false)
        CheckpointDot(level: 3, reached: false, selected: true,  isUnlocked: true)
        CheckpointDot(level: 4, reached: true,  selected: true,  isUnlocked: true)
    }
    .padding()
    .background(Color(.systemGroupedBackground))
}
