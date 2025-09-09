//
//  TabBar.swift
//  Zoomies
//
//  Created by Guilherme Ghise Rossoni on 08/09/25.
//

import SwiftUI
import SwiftData

struct TabBar: View {
    @Environment(\.modelContext) private var context
    var body: some View {
        TabView {
            
            // Mapa
            MapView()
                .tabItem {
                    Label("Mapa", systemImage: "map.fill")
                }
            
            // Home
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            
            // Missões
            MissionView()
                .tabItem {
                    Label("Missões", systemImage: "target")
                }
        }
    }
}

