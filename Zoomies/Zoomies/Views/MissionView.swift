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
    
    @State var selectedMission: Mission?
    @State var isPresented: Bool = false
    @State var coins: Int = 0
    @State var gems: Int = 0
    
    var body: some View {
        
        NavigationStack {
            VStack {
                
                HStack(alignment: .center) {
                    Text("\(coins) coins")
                    Text("\(gems) gems")
                }
                
                GeometryReader { geo in
                    VStack(spacing: 12) {
                        Text("Missions")
                            .font(.headline)
                        
                        ScrollView(.vertical) {
                            VStack(spacing: 12) {
                                ForEach(viewModel.missions.indices, id: \.self) { index in
                                    MissionCard(mission: viewModel.missions[index], claimAction: {
                                        
                                        if !viewModel.missions[index].rewardClaimed {
                                            
                                            coins += viewModel.missions[index].coinReward
                                            gems += viewModel.missions[index].gemReward
                                            
                                            viewModel.missions[index].rewardClaimed = true
                                        }
                                    })
                                    .onTapGesture {
                                        selectedMission = viewModel.missions[index]
                                    }
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
                    .onAppear {
                        viewModel.mockMissions()
                    }
                    
                }
            }
        }
        .sheet(item: $selectedMission) { mission in
            NavigationStack {
                MissionDetails(mission: mission)
            }
        }
    }
}

#Preview {
    MissionView()
}
