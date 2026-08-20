//
//  RunViewModel.swift
//  WatchSport
//

import Foundation
import SwiftData

@Observable
final class RunViewModel {
    private let exerciseID: PersistentIdentifier
    private let tracker: RunTracking
    private let dailyChallengeService: DailyChallengeService

    let targetMeters: Double

    private(set) var distanceMeters: Double = 0
    private(set) var startDate: Date?
    private(set) var countdownValue: Int? = 3
    private(set) var finishedMeters: Double?
    private(set) var errorMessage: String?

    private var hasStarted = false

    init(
        exerciseID: PersistentIdentifier,
        targetMeters: Double,
        tracker: RunTracking,
        dailyChallengeService: DailyChallengeService
    ) {
        self.exerciseID = exerciseID
        self.targetMeters = targetMeters
        self.tracker = tracker
        self.dailyChallengeService = dailyChallengeService
    }

    var progress: Double {
        guard targetMeters > 0 else { return 0 }
        return min(max(distanceMeters / targetMeters, 0), 1)
    }

    var distanceDescription: String {
        ExerciseAmountFormatter.kilometers(distanceMeters)
    }

    var targetDescription: String {
        "Meta: \(ExerciseAmountFormatter.kilometers(targetMeters)) km"
    }

    var remainingDescription: String {
        "\(ExerciseAmountFormatter.kilometers(max(targetMeters - distanceMeters, 0))) km"
    }

    func start() async {
        guard !hasStarted else { return }
        hasStarted = true

        tracker.onDistanceUpdate = { [weak self] meters in
            self?.updateDistance(meters)
        }

        do {
            for value in stride(from: 3, through: 1, by: -1) {
                countdownValue = value
                try await Task.sleep(for: .seconds(1))
            }

            countdownValue = nil

            try await tracker.start()
            startDate = .now
        } catch is CancellationError {
            countdownValue = nil
            hasStarted = false
        } catch {
            countdownValue = nil
            hasStarted = false
            errorMessage = (error as? LocalizedError)?.errorDescription
                ?? "Não foi possível iniciar a corrida."
        }
    }

    func stop() {
        countdownValue = nil
        tracker.onDistanceUpdate = nil

        Task { [tracker] in
            await tracker.stop()
        }
    }

    private func updateDistance(_ meters: Double) {
        guard finishedMeters == nil else { return }

        distanceMeters = meters

        guard meters >= targetMeters else { return }
        finish(with: meters)
    }

    private func finish(with meters: Double) {
        stop()

        do {
            try dailyChallengeService.completeExercise(with: exerciseID, completedAmount: meters)
            finishedMeters = meters
        } catch {
            errorMessage = "Não foi possível salvar sua corrida."
        }
    }
}
