//
//  Zoomie.swift
//  Zoomies
//
//  Created by Guilherme Ghise Rossoni on 08/09/25.
//

import Foundation

@Observable
public class MissionViewController {
    
    var missions: [Mission] = []
    
    func mockMissions() {
        
        let m1 = Mission(
            name: "Complete meia maratona",
            details: "Percorra 21 km",
            metric: "distance",
            unit: "km",
            kind: .noTier,
            frequency: .unlimited
        )
        m1.target = "10"
        missions.append(m1)
        
        let m2 = Mission(
            name: "Complete uma maratona",
            details: "Percorra 42 km",
            metric: "distance",
            unit: "km",
            kind: .noTier,
            frequency: .unlimited
        )
        m2.target = "10"
        missions.append(m2)
        
        let m3 = Mission(
            name: "Complete uma maratona",
            details: "Percorra 42 km",
            metric: "distance",
            unit: "km",
            kind: .noTier,
            frequency: .unlimited
        )
        m3.target = "10"
        missions.append(m3)
        
        let m4 = Mission(
            name: "Complete uma maratona",
            details: "Percorra 42 km",
            metric: "distance",
            unit: "km",
            kind: .noTier,
            frequency: .unlimited
        )
        m4.target = "10"
        missions.append(m4)

    }
    
    
}
