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
    @EnvironmentObject private var healthKitManager: HealthKitManager
    @StateObject private var vm = MapViewController()
    @Query(sort: \Map.name) private var maps: [Map]

    // Persistência simples
    private let lastSeenStepsKey = "map.lastSeenSteps"
    private let lastSeenDateKey  = "map.lastSeenDate"

    // Estado da animação
    @State private var lastSeenSteps: Int = 0    // de onde animamos
    @State private var animTimer: Timer?         // p/ cancelar animações antigas
    @State private var didSetup = false          // evita duplicar setup em onAppear

    // 👇 variável de debug, só lê do manager
      private var debugStepsToday: Int {
          healthKitManager.stepsToday
      }
    
    var body: some View {
        ZStack {
            Image("backgroundMap")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            GeometryReader { geo in
                let size = geo.size

                ZStack {
                    vm.progressPath()
                        .stroke(Color("progressFill", bundle: .main),
                                style: .init(lineWidth: 20, lineCap: .round, lineJoin: .round))

                    ForEach(vm.checkpointsRender()) { rcp in
                        CheckpointDot(
                            level: rcp.levelDisplay,
                            reached: rcp.isUnlocked,
                            selected: rcp.isSelected,
                            isUnlocked: rcp.isUnlocked,
                            showHaloWhenReached: true,
                            style: .init(
                                baseSize: 44,
                                colorLocked: Color("checkpointLocked", bundle: .main),
                                colorUnlocked: Color("checkpointUnlocked", bundle: .main),
                                background: .white,
                                borderWidth: 5
                            )
                        )
                        .position(vm.pointAt(rcp.t))
                    }

                    Circle()
                        .fill(.red)
                        .frame(width: 24, height: 24)
                        .position(vm.pointAt(vm.progresso))
                        .animation(.spring(response: 0.28, dampingFraction: 0.7), value: vm.progresso)
                }
                .onAppear {
                    vm.updateGeometry(for: size)
                    vm.configure(map: maps.first, playerDistance: 0)
                    if !didSetup {
                        didSetup = true
                        // carrega baseline persistido e posiciona o player lá
                        lastSeenSteps = loadLastSeenStepsConsideringDayReset()
                        vm.updatePlayerDistance(Double(lastSeenSteps))
                        // anima do último visto → passos atuais
                        animateFromLastSeenToCurrent()
                    }
                }
                .onChange(of: size) { vm.updateGeometry(for: $0) }
                .onChange(of: maps) { _, _ in
                    vm.configure(map: maps.first, playerDistance: vm.playerDistance)
                    // reanima se trocar o mapa (raro, mas garante)
                    animateFromLastSeenToCurrent()
                }
                .onChange(of: healthKitManager.stepsToday) { _, _ in
                    // chegou um novo valor do HealthKit → anima do que o usuário viu por último
                    animateFromLastSeenToCurrent()
                }
            }
        }
        .onDisappear {
            // salva o último visto quando sair da tela
            persistLastSeen(steps: currentTargetSteps())
            cancelAnim()
        }
    }

    // MARK: - Persistência e dia novo

    private func todayKeyString() -> String {
        let f = DateFormatter()
        f.calendar = Calendar.current
        f.locale = Locale(identifier: "en_US_POSIX")
        f.dateFormat = "yyyy-MM-dd"
        return f.string(from: Date())
    }

    /// Carrega o baseline; se trocou o dia ou os passos atuais < último visto, reseta para 0.
    private func loadLastSeenStepsConsideringDayReset() -> Int {
        let storedDate = UserDefaults.standard.string(forKey: lastSeenDateKey)
        let today = todayKeyString()
        let storedSteps = UserDefaults.standard.integer(forKey: lastSeenStepsKey)
        let current = healthKitManager.stepsToday

        // Virou o dia (datas diferentes) OU passos atuais menores (reset diário do HK)?
        if storedDate != today || current < storedSteps {
            persistLastSeen(steps: 0) // zera baseline pro novo dia
            return 0
        }
        return storedSteps
    }

    private func persistLastSeen(steps: Int) {
        UserDefaults.standard.set(steps, forKey: lastSeenStepsKey)
        UserDefaults.standard.set(todayKeyString(), forKey: lastSeenDateKey)
        lastSeenSteps = steps
    }

    // MARK: - Cálculo do alvo e animação

    /// Passos alvo limitados ao mapa (último checkpoint).
    private func currentTargetSteps() -> Int {
        guard let map = vm.currentMap ?? maps.first else { return 0 }
        let maxSteps = Int(map.checkpoints.map(\.distance).max() ?? 0)
        return min(max(0, healthKitManager.stepsToday), maxSteps)
    }

    private func cancelAnim() {
        animTimer?.invalidate()
        animTimer = nil
    }

    /// Anima de `lastSeenSteps` (persistido) até `stepsToday` (clamp no mapa).
    private func animateFromLastSeenToCurrent() {
        guard let _ = vm.currentMap ?? maps.first else { return }

        let target = currentTargetSteps()

        // Se os passos diminuíram (ex.: reset do dia em tempo real), recomeça do 0.
        if target < lastSeenSteps {
            persistLastSeen(steps: 0)
        }

        let from = lastSeenSteps
        let to   = max(lastSeenSteps, target) // nunca volta "para trás" visualmente

        // Nada a animar
        guard to > from else { return }

        cancelAnim()

        let totalDelta = to - from
        // frames proporcionais ao delta para suavidade, com limites
        let frames = min(90, max(24, totalDelta / 50))
        let stepPerTick = max(1, totalDelta / frames)
        var current = from

        animTimer = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { timer in
            current += stepPerTick
            if current >= to {
                current = to
                timer.invalidate()
                self.animTimer = nil
            }
            withAnimation(.linear(duration: 0.02)) {
                vm.updatePlayerDistance(Double(current)) // “distância” = passos
            }
            if current == to {
                // Atualiza o “último visto” quando termina
                persistLastSeen(steps: to)
            }
        }
    }
}

