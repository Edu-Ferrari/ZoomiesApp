//
//  CheckpointDot.swift
//  Zoomies
//
//  Created by Guilherme Ghise Rossoni on 09/09/25.
//

import SwiftUI

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

public struct CheckpointDot: View {
    public let level: Int
    public let reached: Bool      // já alcançado pela distância?
    public let selected: Bool     // está selecionado/hover?
    public let isUnlocked: Bool   // estado lógico vindo do domínio
    public let showHaloWhenReached: Bool
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
            // Disco base
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
