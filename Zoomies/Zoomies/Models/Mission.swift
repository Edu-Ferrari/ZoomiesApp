////
////  Zoomie.swift
////  Zoomies
////
////  Created by Guilherme Ghise Rossoni on 08/09/25.
////
//
//import Foundation
//
//public class Mission {
//    var id: UUID
//    var name: String
//    var description: String
//    var startDate: Date?
//    var endDate: Date?
//    
//    init(
//        id: UUID = UUID(),
//        name: String,
//        description: String,
//        startDate: Date? = nil,
//        endDate: Date? = nil
//    ) {
//        self.id = id
//        self.name = name
//        self.description = description
//        self.startDate = startDate
//        self.endDate = endDate
//    }
//}
//
//public class MissionWithTier: Mission {
//    var tier: Int
//    var distanceBronze: Double
//    var distanceSilver: Double
//    var distanceGold: Double
//    var rewardBronze: Bool
//    var rewardSilver: Bool
//    var rewardGold: Bool
//    var emblemBronze: Bool
//    var emblemSilver: Bool
//    var emblemGold: Bool
//    
//    init(
//        id: UUID = UUID(),
//        name: String,
//        description: String,
//        startDate: Date? = nil,
//        endDate: Date? = nil,
//        tier: Int,
//        distanceBronze: Double,
//        distanceSilver: Double,
//        distanceGold: Double,
//        rewardBronze: Double,
//        rewardSilver: Double,
//        rewardGold: Double,
//        emblemBronze: Double,
//        emblemSilver: Double,
//        emblemGold: Double
//    ) {
//        self.tier = tier
//        self.distanceBronze = distanceBronze
//        self.distanceSilver = distanceSilver
//        self.distanceGold = distanceGold
//        self.rewardBronze = rewardBronze
//        self.rewardSilver = rewardSilver
//        self.rewardGold = rewardGold
//        self.emblemBronze = emblemBronze
//        self.emblemSilver = emblemSilver
//        self.emblemGold = emblemGold
//        
//        super.init(
//            id: id,
//            name: name,
//            description: description,
//            startDate: startDate,
//            endDate: endDate
//        )
//    }
//}
