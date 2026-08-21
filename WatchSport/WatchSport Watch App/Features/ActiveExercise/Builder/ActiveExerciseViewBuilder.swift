//
//  ActiveExerciseViewBuilder.swift
//  WatchSport
//

import SwiftData

enum ActiveExerciseViewBuilder {
    @MainActor
    static func build(
        route: ActiveExerciseRoute,
        modelContext: ModelContext,
        onCompleted: @escaping (Double) -> Void = { _ in }
    ) -> ActiveExerciseView {
        let dailyChallengeService = DailyChallengeService(modelContext: modelContext)

        let viewModel = ActiveExerciseViewModel(
            exerciseType: route.exerciseType,
            targetRepetitions: route.targetRepetitions,
            onGoalReached: { completedRepetitions in
                guard let exerciseID = route.exerciseID else { return }

                try dailyChallengeService.completeExercise(
                    with: exerciseID,
                    completedAmount: Double(completedRepetitions)
                )
            }
        )

        return ActiveExerciseView(viewModel: viewModel, onCompleted: onCompleted)
    }
}
