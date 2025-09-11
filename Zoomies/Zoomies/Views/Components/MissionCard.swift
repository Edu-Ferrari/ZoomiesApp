//
//  MissionCard.swift
//  Zoomies
//
//  Created by Gabriel Barbosa on 10/09/25.
//

import SwiftUI

struct MissionCard: View {
    
    var mission: Mission
    
    var body: some View {
        
        HStack(spacing: 16) {
            
            Circle()
                .frame(width: 54, height: 54)
            
            VStack() {
                
                Text("\(mission.name)")
                
                MissionProgressBar(progress: mission.progress, goal: mission.goal, metric: mission.metric)
                
            }
            
            VStack {
                
                Text("\(mission.coinReward) coins")
                Text("\(mission.gemReward) gems")
                
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

#Preview {
    
    let m1 = Mission(name: "Missão 1", details: "Percorra 10 Km", metric: "km", progress: 10, goal: 10, coinReward: 15, gemReward: 5)
    MissionCard(mission: m1)
}
