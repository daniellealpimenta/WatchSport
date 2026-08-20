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
        onCompleted: @escaping () -> Void = {}
    ) -> ActiveExerciseView {
        let completionService = ExerciseCompletionService(
            modelContext: modelContext
        )

        let viewModel = ActiveExerciseViewModel(
            exerciseType: route.exerciseType,
            targetRepetitions: route.targetRepetitions,
            onGoalReached: { completedRepetitions in
                if let exerciseID = route.exerciseID {
                    try completionService.complete(
                        exerciseID: exerciseID,
                        completedAmount: Double(completedRepetitions)
                    )
                }

                onCompleted()
            }
        )

        return ActiveExerciseView(viewModel: viewModel)
    }
}
