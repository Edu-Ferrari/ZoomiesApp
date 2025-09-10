    //  TabBar.swift
    //  Zoomies
    //
    //  Created by Guilherme Ghise Rossoni on 08/09/25.
    //

import SwiftUI

struct TabBar: View {
    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.white

        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        TabView {
            // Mapa
            MapView()
                .tabItem {
                    Label("Mapa", systemImage: "map.fill")
                }
            
            // Pet
            PetView()
                .tabItem {
                    Label("Pet", systemImage: "house.fill")
                }
            
            // Loja
            ShopView()
                .tabItem {
                    Label("Loja", systemImage: "cart.fill")
                }
            
            
            // Missões
            MissionView()
                .tabItem {
                    Label("Missões", systemImage: "target")
                }
        }
    }
}


#Preview {
    TabBar()
}
