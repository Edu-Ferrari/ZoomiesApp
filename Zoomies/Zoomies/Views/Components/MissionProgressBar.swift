//
//  MissionProgressBar.swift
//  Zoomies
//
//  Created by Gabriel Barbosa on 11/09/25.
//

import SwiftUI

struct MissionProgressBar: View {
    
    var progress: Double
    var goal: Double
    var metric: String
    
    var body: some View {
        GeometryReader { geometry in
            
            ZStack(alignment: .leading) {
                
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.3))
                
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.blue)
                    .frame(width: calculateProgressWidth(containerWidth: geometry.size.width))

                ZStack {
                    if metric == "km" {
                        let formattedProgress = String(format: "%.2f", progress)
                        let formattedGoal = String(format: "%.2f", goal)
                        Text("\(formattedProgress) / \(formattedGoal) km")
                    
                        
                    } else {
                        let formattedProgress = String(format: "%.0f", progress)
                        let formattedGoal = String(format: "%.0f", goal)
                        Text("\(formattedProgress) / \(formattedGoal) steps")
                            
                    }
                }
                .frame(width: geometry.size.width)
            }
        }
        .frame(height: 15)
    }
    
    private func calculateProgressWidth(containerWidth: CGFloat) -> CGFloat {
        if goal <= 0 { return 0 }
        
        let progressFraction = progress / goal
        
        let clampedFraction = max(0, min(progressFraction, 1))

        return containerWidth * clampedFraction
    }
}

#Preview {
    MissionProgressBar(progress: 10, goal: 20, metric: "km")
}
