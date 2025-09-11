
//import SwiftUI
//import SwiftData
//
//struct TabBar: View {
//    @Environment(\.modelContext) private var context
//    var body: some View {
//        TabView {
//            
//            // Mapa
//            MapView()
//                .tabItem {
//                    Label("Mapa", systemImage: "map.fill")
//                }
//            
//            // Home
//            HomeView()
//                .tabItem {
//                    Label("Home", systemImage: "house.fill")
//                }
//            
//            // Missões
//            MissionView()
//                .tabItem {
//                    Label("Missões", systemImage: "target")
//                }
//        }
//    }
//}

//
//  TabBar.swift
//  Zoomies
//
//  Created by Eduardo Ferrari 11/09/25.
//

import SwiftUI
import SwiftData

struct TabBar: View {
    @Environment(\.modelContext) private var context
    @EnvironmentObject private var healthKitManager: HealthKitManager
    
    var body: some View {
        TabView {
            MapView()
                .tabItem {
                    Label("Mapa", systemImage: "map.fill")
                }
            
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .badge(healthKitManager.stepsToday > 0 ? "\(healthKitManager.stepsToday)" : nil)
            
            MissionView()
                .tabItem {
                    Label("Missões", systemImage: "target")
                }
        }
        .onAppear {
            // Atualiza dados quando a TabBar aparece
            if healthKitManager.authState == .authorized {
                healthKitManager.fetchAllStats()
            }
        }
    }
}
