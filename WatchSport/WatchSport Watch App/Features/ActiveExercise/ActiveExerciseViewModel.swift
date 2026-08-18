//
//  ActiveExerciseViewModel.swift
//  WatchSport
//

import Combine
import Dispatch
import ExercisesPackage
import Observation

@MainActor
@Observable
final class ActiveExerciseViewModel {
    let exerciseType: ExerciseType
    let targetRepetitions: Int

    private(set) var completedRepetitions = 0
    private(set) var isCompleted = false
    private(set) var countdownValue: Int? = 3
    private(set) var hasError = false
    private(set) var errorMessage = ""

    @ObservationIgnored private let tracker: ExerciseTracker
    @ObservationIgnored private var cancellables = Set<AnyCancellable>()
    @ObservationIgnored private var hasStarted = false
    @ObservationIgnored private let onGoalReached: (Int) throws -> Void

    init(
        exerciseType: ExerciseType,
        targetRepetitions: Int,
        onGoalReached: @escaping (Int) throws -> Void
    ) {
        guard let trackerType = exerciseType.trackerType else {
            preconditionFailure("Running uses a dedicated tracking flow")
        }

        self.exerciseType = exerciseType
        self.targetRepetitions = max(targetRepetitions, 1)
        self.tracker = ExerciseTracker(type: trackerType)
        self.onGoalReached = onGoalReached

        observeRepetitionCount()
    }

    var title: String {
        exerciseType.displayName
    }

    var remainingRepetitions: Int {
        max(targetRepetitions - completedRepetitions, 0)
    }

    var progress: Double {
        min(Double(completedRepetitions) / Double(targetRepetitions), 1)
    }

    var remainingDescription: String {
        isCompleted ? "Meta concluída" : "Faltam \(remainingRepetitions)"
    }

    var displayedCount: Int {
        completedRepetitions
    }

    var countDescription: String {
        "de \(targetRepetitions) repetições"
    }

    var statusDescription: String {
        remainingDescription
    }

    func start() async {
        guard !hasStarted, !isCompleted else { return }
        hasStarted = true
        hasError = false
        errorMessage = ""

        do {
            for value in stride(from: 3, through: 1, by: -1) {
                countdownValue = value
                try await Task.sleep(for: .seconds(1))
            }

            countdownValue = nil
            tracker.start()

            guard tracker.isRecording else {
                hasStarted = false
                hasError = true
                errorMessage = "Não foi possível acessar os sensores de movimento."
                return
            }
        } catch {
            countdownValue = nil
            hasStarted = false
        }
    }

    func stop() {
        tracker.stop()
        countdownValue = nil
        hasStarted = false
    }

    private func observeRepetitionCount() {
        tracker.$count
            .receive(on: DispatchQueue.main)
            .sink { [weak self] count in
                self?.updateRepetitionCount(count)
            }
            .store(in: &cancellables)
    }

    private func updateRepetitionCount(_ count: Int) {
        completedRepetitions = min(max(count, 0), targetRepetitions)

        guard completedRepetitions >= targetRepetitions, !isCompleted else { return }
        hasStarted = false
        tracker.stop()

        do {
            try onGoalReached(completedRepetitions)
            isCompleted = true
        } catch {
            hasError = true
            errorMessage = "Não foi possível salvar a conclusão do exercício."
        }
    }
}
