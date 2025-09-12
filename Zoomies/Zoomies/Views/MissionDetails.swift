//
//  MissionDetails.swift
//  Zoomies
//
//  Created by Gabriel Barbosa on 12/09/25.
//

import SwiftUI

struct MissionDetails: View {
    
    @Environment(\.dismiss) var dismiss
    var mission: Mission
    
    private var missionStatus: (text: String, color: Color) {
        if mission.rewardClaimed {
            return ("Completa", .green)
        } else if mission.progress >= mission.goal {
            return ("Resgate disponível", .blue)
        } else {
            return ("Em andamento", .orange)
        }
    }
    
    var body: some View {
        
        NavigationStack {
            VStack(alignment: .center) {
                
                Circle()
                    .fill(Color.blue)
                    .frame(width: 80, height: 80)
                
                Text(mission.name)
                    .font(.headline)
                
                Text(mission.details)
                
                MissionProgressBar(progress: mission.progress, goal: mission.goal, metric: mission.metric)
                
                VStack {
                    Text("Status: ")
                    + Text("\(missionStatus.text)")
                        .foregroundStyle(missionStatus.color)
                    
                    HStack {
                        
                        Text("Moedas: \(mission.coinReward)")
                        
                        Text("Gemas: \(mission.gemReward)")
        
                    }
                }
                .padding(8)
            }
            .padding()
            
        }
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Feito") {
                    dismiss()
                }
            }
            
        }
        
    }
}

#Preview {
    let m1 = Mission(name: "Missão 1", details: "Percorra 10 Km", metric: "km", progress: 9, goal: 10, coinReward: 15, gemReward: 5)
    NavigationStack {
        MissionDetails(mission: m1)
    }
}
