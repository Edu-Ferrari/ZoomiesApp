//
//  HealthKitManager.swift
//  Zoomies
//
//  Created by Eduardo Ferrari on 11/09/25.
//

import Foundation
import HealthKit
import Combine
import UIKit

final class HealthKitManager: ObservableObject {
    // MARK: - Singleton
    static let shared = HealthKitManager()
    private init() {
        observeAppState()
        refreshAuthState()
    }

    // MARK: - Public @Published
    enum AuthState: Equatable { case unknown, authorizing, authorized, denied }
    @Published var authState: AuthState = .unknown
    @Published var authorizationError: String?
    
    @Published var stepsToday = 0
    @Published var distanceTodayKm = 0.0
    @Published var weeklySteps = 0
    @Published var weeklyDistanceKm = 0.0
    @Published var totalSteps = 0
    @Published var totalDistanceKm = 0.0

    // MARK: - Private
    private let healthStore = HKHealthStore()
    private var observerQuery: HKObserverQuery?
    private var cancellables = Set<AnyCancellable>()
    private let startDateKey = "appStartDate"

    private var readTypes: Set<HKObjectType> {
        [.quantityType(forIdentifier: .stepCount),
         .quantityType(forIdentifier: .distanceWalkingRunning)]
            .compactMap { $0 }
            .reduce(into: Set<HKObjectType>()) { $0.insert($1) }
    }
    
    private func publishAuth(_ state: AuthState) {
        DispatchQueue.main.async {
            if self.authState != state {
                self.authState = state
            }
        }
    }

    func refreshAuthState() {
        var allAuthorized = true
        var anyDenied = false
        
        for readType in readTypes {
            if let quantityType = readType as? HKQuantityType {
                let status = healthStore.authorizationStatus(for: quantityType)
                
                switch status {
                case .sharingAuthorized:
                    break
                case .sharingDenied:
                    anyDenied = true
                default:
                    allAuthorized = false
                }
            }
        }
        
        if allAuthorized {
            if authState != .authorized {
                publishAuth(.authorized)
                handleAuthorizationSuccess()
            }
        } else if anyDenied {
            publishAuth(.denied)
        } else {
            publishAuth(.unknown)
        }
    }

    private func handleAuthorizationSuccess() {
        startObservingData()
        startObservingPermissionChanges()
        fetchAllStats()
    }
    
    func requestAuthorization() {
        guard HKHealthStore.isHealthDataAvailable() else {
            DispatchQueue.main.async {
                self.authorizationError = "Health data indisponível neste dispositivo."
                self.publishAuth(.denied)
            }
            return
        }
        
        publishAuth(.authorizing)

        healthStore.requestAuthorization(toShare: [], read: readTypes) { [weak self] success, error in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                if let error = error {
                    self.authorizationError = error.localizedDescription
                    self.publishAuth(.denied)
                    return
                }
                
                self.refreshAuthState()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.refreshAuthState()
                }
            }
        }
    }

    private func startObservingPermissionChanges() {
        NotificationCenter.default.addObserver(
            forName: .healthStoreDidChange,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.refreshAuthState()
        }
        
        NotificationCenter.default.addObserver(
            forName: UIApplication.didBecomeActiveNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.refreshAuthState()
        }
    }
    
    func openSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString),
           UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }

    private func observeAppState() {
        NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in self?.handleAppDidBecomeActive() }
            .store(in: &cancellables)
    }

    private func handleAppDidBecomeActive() {
        if authState != .authorized {
            refreshAuthState()
        } else {
            fetchAllStats()
        }
    }
    
    private var isDistanceAuthorized: Bool {
        guard let dist = HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning) else { return false }
        return healthStore.authorizationStatus(for: dist) == .sharingAuthorized
    }

    var appStartDate: Date {
        if let saved = UserDefaults.standard.object(forKey: startDateKey) as? Date { return saved }
        let now = Date(); UserDefaults.standard.set(now, forKey: startDateKey); return now
    }
    
    func fetchAllStats() {
        fetchTodaySteps()
        if isDistanceAuthorized {
            fetchTodayDistance()
        } else {
            DispatchQueue.main.async {
                self.distanceTodayKm = 0
            }
        }
        fetchWeeklyStats()
        fetchTotalStats()
    }

    private func startObservingData() {
        for type in readTypes {
            if let q = observerQuery { healthStore.stop(q) }
            
            let query = HKObserverQuery(sampleType: type as! HKSampleType, predicate: nil) { [weak self] _, completion, _ in
                self?.fetchAllStats()
                completion()
            }
            healthStore.execute(query)
            healthStore.enableBackgroundDelivery(for: type, frequency: .immediate) { _, _ in }
            self.observerQuery = query
        }
    }

    func fetchTodaySteps(completion: (() -> Void)? = nil) {
        let startOfDay = Calendar.current.startOfDay(for: Date())
        fetchSteps(from: startOfDay, to: Date()) { steps in
            DispatchQueue.main.async { self.stepsToday = steps; completion?() }
        }
    }

    func fetchTodayDistance() {
        let startOfDay = Calendar.current.startOfDay(for: Date())
        fetchDistance(from: startOfDay, to: Date()) { distance in
            DispatchQueue.main.async { self.distanceTodayKm = distance }
        }
    }

    func fetchWeeklyStats() {
        guard let weekAgo = Calendar.current.date(byAdding: .day, value: -6, to: Date()) else { return }
        fetchSteps(from: weekAgo, to: Date()) { steps in
            DispatchQueue.main.async { self.weeklySteps = steps }
        }
        if isDistanceAuthorized {
            fetchDistance(from: weekAgo, to: Date()) { dist in
                DispatchQueue.main.async { self.weeklyDistanceKm = dist }
            }
        } else { DispatchQueue.main.async { self.weeklyDistanceKm = 0 } }
    }

    func fetchTotalStats() {
        fetchSteps(from: self.appStartDate, to: Date()) { steps in
            DispatchQueue.main.async { self.totalSteps = steps }
        }
        if isDistanceAuthorized {
            fetchDistance(from: self.appStartDate, to: Date()) { dist in
                DispatchQueue.main.async { self.totalDistanceKm = dist }
            }
        } else { DispatchQueue.main.async { self.totalDistanceKm = 0 } }
    }

    private func fetchSteps(from start: Date, to end: Date, completion: @escaping (Int) -> Void) {
        guard let type = HKQuantityType.quantityType(forIdentifier: .stepCount) else { completion(0); return }
        let predicate = HKQuery.predicateForSamples(withStart: start, end: end)
        let query = HKStatisticsQuery(quantityType: type, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, _ in
            completion(Int(result?.sumQuantity()?.doubleValue(for: .count()) ?? 0))
        }
        healthStore.execute(query)
    }

    private func fetchDistance(from start: Date, to end: Date, completion: @escaping (Double) -> Void) {
        guard let type = HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning) else { completion(0); return }
        let predicate = HKQuery.predicateForSamples(withStart: start, end: end)
        let query = HKStatisticsQuery(quantityType: type, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, _ in
            completion(result?.sumQuantity()?.doubleValue(for: HKUnit.meter()) ?? 0 / 1000.0)
        }
        healthStore.execute(query)
    }
}

extension Notification.Name {
    static let healthStoreDidChange = Notification.Name("HKHealthStoreDidChangeNotification")
}
