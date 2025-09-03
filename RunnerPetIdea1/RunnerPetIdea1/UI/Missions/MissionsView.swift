//
//  MissionsView.swift
//  RunnerPetIdea1
//
//  Created by Eduardo Ferrari on 02/09/25.
//


import SwiftUI
import SwiftData

struct MissionsView: View {
    @Environment(\.modelContext) private var ctx
    @Query private var missions: [MissionProgress]
    @Query private var profiles: [UserProfile]

    var body: some View {
        NavigationStack {
            List {
                ForEach(missions) { m in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(m.missionId).font(.headline)
                            ProgressView(value: m.currentKm, total: m.targetKm)
                        }
                        Spacer()
                        if m.isCompleted && m.claimedAt == nil {
                            Button("Resgatar") { claim(m) }
                                .buttonStyle(.borderedProminent)
                        }
                    }
                }
            }
            .navigationTitle("Missões")
        }
    }

    private func claim(_ m: MissionProgress) {
        guard let p = profiles.first else { return }
        p.gems += 20
        m.claimedAt = .now
        try? ctx.save()
    }
}
