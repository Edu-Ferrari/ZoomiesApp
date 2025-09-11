//
//  Zoomie.swift
//  Zoomies
//
//  Created by Guilherme Ghise Rossoni on 08/09/25.
//
// Navegação principal do app. Aplica aparência do UITabBar e
// injeta dados iniciais (SeedOnceView) antes de exibir as abas.

import SwiftUI
import SwiftData

struct TabBar: View {
    @Environment(\.modelContext) private var context
    
    /// Configura a aparência do `UITabBar` para fundo opaco branco.
    /// Feito no init porque precisa ser aplicado antes da renderização.
    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }

    var body: some View {
        // `SeedOnceView` garante que os dados iniciais existam no container
        // antes das telas que dependem deles (ex.: MapView) serem mostradas.
        SeedOnceView {
            TabView {
                /// Mapa
                MapView()
                    .tabItem { Label("Mapa", systemImage: "map.fill") }
                
                /// Pet
                PetView()
                    .tabItem { Label("Pet", systemImage: "house.fill") }
                
                /// Loja
                ShopView()
                    .tabItem { Label("Loja", systemImage: "cart.fill") }

                /// Missões
                MissionView()
                    .tabItem { Label("Missões", systemImage: "target") }
            }
        }
    }
}
