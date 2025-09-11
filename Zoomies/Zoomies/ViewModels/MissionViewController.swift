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
        
        let m1 = Mission(name: "Missão 1", details: "Percorra 10 Km", metric: "km", progress: 5, goal: 10, coinReward: 15, gemReward: 5)
        let m2 = Mission(name: "Missão 2", details: "Percorra 20 Km", metric: "km", progress: 5, goal: 20, coinReward: 30, gemReward: 10)
        let m3 = Mission(name: "Missão 3", details: "Percorra 30 Km", metric: "km", progress: 5, goal: 30, coinReward: 45, gemReward: 15)
        
        missions.append(contentsOf: [m1, m2, m3])
    }
    
    
}
