//
//  HealthKitRunTracking.swift
//  WatchSport
//

import Foundation
import HealthKit

final class HealthKitRunTracking: NSObject, RunTracking {
    var onDistanceUpdate: ((Double) -> Void)?

    private let healthStore = HKHealthStore()
    private let distanceType = HKQuantityType(.distanceWalkingRunning)

    private var session: HKWorkoutSession?
    private var builder: HKLiveWorkoutBuilder?

    func start() async throws {
        guard HKHealthStore.isHealthDataAvailable() else {
            throw RunTrackingError.healthDataUnavailable
        }

        do {
            try await healthStore.requestAuthorization(
                toShare: [HKQuantityType.workoutType()],
                read: [distanceType, HKQuantityType(.heartRate), HKQuantityType(.activeEnergyBurned)]
            )
        } catch {
            throw RunTrackingError.authorizationDenied
        }

        let configuration = HKWorkoutConfiguration()
        configuration.activityType = .running
        configuration.locationType = .outdoor

        let session = try HKWorkoutSession(healthStore: healthStore, configuration: configuration)
        let builder = session.associatedWorkoutBuilder()
        builder.dataSource = HKLiveWorkoutDataSource(
            healthStore: healthStore,
            workoutConfiguration: configuration
        )
        builder.delegate = self

        let startDate = Date()
        session.startActivity(with: startDate)
        try await builder.beginCollection(at: startDate)

        self.session = session
        self.builder = builder
    }

    func stop() async {
        guard let session, let builder else { return }

        self.session = nil
        self.builder = nil
        builder.delegate = nil

        session.end()
        try? await builder.endCollection(at: Date())
        _ = try? await builder.finishWorkout()
    }
}

extension HealthKitRunTracking: HKLiveWorkoutBuilderDelegate {

    nonisolated func workoutBuilder(
        _ workoutBuilder: HKLiveWorkoutBuilder,
        didCollectDataOf collectedTypes: Set<HKSampleType>
    ) {
        let distanceType = HKQuantityType(.distanceWalkingRunning)
        guard collectedTypes.contains(distanceType) else { return }

        let meters = workoutBuilder
            .statistics(for: distanceType)?
            .sumQuantity()?
            .doubleValue(for: .meter()) ?? 0

        Task { @MainActor [weak self] in
            self?.onDistanceUpdate?(meters)
        }
    }

    nonisolated func workoutBuilderDidCollectEvent(_ workoutBuilder: HKLiveWorkoutBuilder) {}
}
