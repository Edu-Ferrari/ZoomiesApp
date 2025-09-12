//
//  MissionCard.swift
//  Zoomies
//
//  Created by Gabriel Barbosa on 10/09/25.
//

import SwiftUI

struct MissionCard: View {
    
    var mission: Mission
    var claimAction: () -> Void
    
    var body: some View {
        
        HStack(spacing: 16) {
            
            Circle()
                .frame(width: 54, height: 54)
            
            VStack() {
                
                Text("\(mission.name)")

                MissionProgressBar(progress: mission.progress, goal: mission.goal, metric: mission.metric)
                
            }
            if mission.progress >= mission.goal && !mission.rewardClaimed {
                Button(action: claimAction) {
                    VStack {
                        
                        Text("\(mission.coinReward) coins")
                            .foregroundStyle(.yellow)
                        
                        Text("\(mission.gemReward) gems")
                            .foregroundStyle(.purple)
                        
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.black)
                    )
                }
                
            } else if mission.rewardClaimed {
                VStack {
                    
                    Text("Reward")
                        .foregroundStyle(.yellow)
                    
                    Text("Claimed")
                        .foregroundStyle(.purple)
                    
                }
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.black)
                )
            } else {
                VStack {
                    
                    Text("\(mission.coinReward) coins")
                    
                    Text("\(mission.gemReward) gems")
                    
                }
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.white)
                )
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.red)
        )
    }
}
