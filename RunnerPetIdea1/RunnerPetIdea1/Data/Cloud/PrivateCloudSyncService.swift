//
//  PrivateCloudSyncService.swift
//  RunnerPetIdea1
//
//  Created by Eduardo Ferrari on 02/09/25.
//

import CloudKit
import SwiftData
import Foundation


@MainActor
final class PrivateCloudSyncService: ObservableObject {
    func restoreSnapshot(ctx: ModelContext) async {}
    func backupSnapshot(supplier: () -> Void = {}) {}
}
