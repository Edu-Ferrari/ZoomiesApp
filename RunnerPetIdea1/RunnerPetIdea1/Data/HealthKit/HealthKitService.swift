//
//  HealthKitService.swift
//  RunnerPetIdea1
//
//  Created by Eduardo Ferrari on 02/09/25.
//

import Foundation
import SwiftData

@MainActor
final class HealthKitService: ObservableObject {
    init(ctx: ModelContext) {}
    func requestAuthorization() async throws {}
    func startObservers() {}
    func fetchAnchored(for id: Any) async {}
}
