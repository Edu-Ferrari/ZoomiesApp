//
//  MapView.swift
//  RunnerPetIdea1
//
//  Created by Eduardo Ferrari on 02/09/25.
//


import SwiftUI
import SwiftData

struct MapDotButton: View {
    let filled: Bool
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            Image(filled ? "map/bg_dot_on" : "map/bg_dot_off")
                .resizable().frame(width: 28, height: 28)
        }.buttonStyle(.plain)
    }
}

struct MapView: View {
    @Environment(\.modelContext) private var ctx
    @Query private var profiles: [UserProfile]
    @Query private var progresses: [MapProgress]
    let repo = MapRepository()

    @State private var showDotSheet = false
    @State private var selectedDot = 0

    private var currentDef: MapDef {
        let id = profiles.first?.currentMapId ?? "world1"
        return repo.byId(id) ?? repo.all().first!
    }
    private var currentDotIndex: Int { progresses.first(where: { $0.mapId == currentDef.id })?.dotIndex ?? 0 }

    var body: some View {
        ZStack {
            Image(currentDef.backgroundAsset).resizable().scaledToFill().ignoresSafeArea()
            VStack(spacing: 20) {
                Text(currentDef.name).font(.title2.bold()).padding(.top, 20)
                HStack(spacing: 12) {
                    ForEach(0..<10, id: \.self) { idx in
                        MapDotButton(filled: idx <= currentDotIndex) {
                            selectedDot = idx; showDotSheet = true
                        }
                    }
                }
                Spacer()
            }
            .padding(.horizontal)
        }
        .sheet(isPresented: $showDotSheet) {
            VStack(spacing: 16) {
                Text("Etapa #\(selectedDot + 1)").font(.title3.bold())
                Text("Ações: ver recompensa / meta.")
                Button("Fechar") { showDotSheet = false }
                    .buttonStyle(.borderedProminent)
            }.padding()
        }
    }
}
