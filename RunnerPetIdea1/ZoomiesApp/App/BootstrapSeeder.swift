//
//  BootstapSeeder.swift
//  RunnerPetIdea1
//
//  Created by Eduardo Ferrari on 02/09/25.
//

//import SwiftData
//import Foundation
//
//@MainActor
//enum BootstrapSeeder {
//    static func seedIfNeeded(ctx: ModelContext) {
//        let profiles = (try? ctx.fetch(FetchDescriptor<UserProfile>())) ?? []
//        if profiles.isEmpty {
//            let prof = UserProfile(userId: UUID().uuidString, displayName: "Runner", gems: 100, currentMapId: "world1")
//            let progress = MapProgress(mapId: "world1")
//            let loadout = Loadout()
//            ctx.insert(prof); ctx.insert(progress); ctx.insert(loadout)
//            try? ctx.save()
//        }
//    }
//}
