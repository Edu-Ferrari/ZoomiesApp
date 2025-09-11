//
//  MissionCard.swift
//  Zoomies
//
//  Created by Gabriel Barbosa on 10/09/25.
//

import SwiftUI

struct MissionCard: View {
    
    var mission: Mission
    var progress: Int = 30
    
    var body: some View {
        
        
        HStack(spacing: 16) {
            
            Circle()
                .frame(width: 54, height: 54)
            
            VStack() {
                
                Text("\(mission.name)")
                
                if let target = mission.target {
                    Text("\(progress) / \(target)")
                        .frame(width: 158)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.blue)
                        )
                }
            }
            
            Circle()
                .frame(width: 54, height: 54)
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
    MissionCard(mission: {
        let m = Mission(
            name: "Complete uma maratona",
            details: "Percorra 42 km",
            metric: "distance",
            unit: "km",
            kind: .noTier,
            frequency: .unlimited
        )
        m.target = "10"
        return m
    }())
}
