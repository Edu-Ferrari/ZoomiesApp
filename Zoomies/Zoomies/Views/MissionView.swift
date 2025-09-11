//
//  Zoomie.swift
//  Zoomies
//
//  Created by Guilherme Ghise Rossoni on 08/09/25.
//

import SwiftUI

private struct ContentHeightKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}

struct MissionView: View {
    @State var viewModel = MissionViewController()
    @State private var listHeight: CGFloat = 0   

    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 12) {
                Text("Missions")
                    .font(.headline)

                ScrollView(.vertical) {
                    VStack(spacing: 12) {
                        ForEach(viewModel.missions, id: \.self) { mission in
                            MissionCard(mission: mission)
                        }
                    }
                    .background(
                        GeometryReader { g in
                            Color.clear
                                .preference(key: ContentHeightKey.self, value: g.size.height)
                        }
                    )
                }
                .frame(height: min(listHeight, geo.size.height * 0.8))
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(Color.green)
            )
            .padding()
            .onPreferenceChange(ContentHeightKey.self) { listHeight = $0 }
            .onAppear { viewModel.mockMissions() }
        }
    }
}



#Preview {
    MissionView()
}
