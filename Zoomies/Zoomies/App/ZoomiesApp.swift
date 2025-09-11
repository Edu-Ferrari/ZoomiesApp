//
//  ZoomiesApp.swift
//  Zoomies
//
//  Created by Eduardo Ferrari on 11/09/25.
//

import SwiftUI
import SwiftData

@main
struct ZoomiesApp: App {
    // Inicializa o HealthKitManager
    @StateObject private var healthKitManager = HealthKitManager.shared
    
    var body: some Scene {
        WindowGroup {
            // Mostra a TabBar apenas se tiver dados, senão mostra a tela de permissão
            if healthKitManager.stepsToday > 0 {
                TabBar()
                    .environmentObject(healthKitManager)
            } else {
                ZStack {
                    Color.black.opacity(0.5).ignoresSafeArea()
                    HealthPermissionView(hk: healthKitManager)
                        .frame(maxWidth: 420)
                        .padding()
                        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 20))
                        .shadow(radius: 20)
                }
                .ignoresSafeArea()
                .environmentObject(healthKitManager)
            }
        }
        .modelContainer(for: [User.self, Zoomie.self, Item.self, Map.self, Checkpoint.self, Emblem.self, Chest.self])
        .onChange(of: healthKitManager.stepsToday) { oldValue, newValue in
            // Reage às mudanças nos passos
            print("StepsToday mudou: \(oldValue) -> \(newValue)")
        }
    }
}
