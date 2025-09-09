//
//  ZoomiesApp.swift
//  Zoomies
//
//  Created by Guilherme Ghise Rossoni on 08/09/25.
//

import SwiftUI
import SwiftData

@main
struct ZoomiesApp: App {
    var body: some Scene {
        WindowGroup {
            TabBar()
        }
        .modelContainer(for: [User.self, Zoomie.self, Item.self, Map.self, Checkpoint.self, Emblem.self, Chest.self])
    }
}
