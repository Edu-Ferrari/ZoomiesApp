//
//  RunnerPetIdea1App.swift
//  RunnerPetIdea1
//
//  Created by Eduardo Ferrari on 02/09/25.
//

import SwiftUI
import SwiftData

@main
struct RunnerPetLiteApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            User.self, Zoomie.self
        ])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        return try! ModelContainer(for: schema, configurations: [config])
    }()

    var body: some Scene {
        WindowGroup {
            RootView()
                .modelContainer(sharedModelContainer)
        }
    }
}

struct RootView: View {
    @Environment(\.modelContext) private var ctx
    var body: some View {
//        MainTabView()
    }
}
