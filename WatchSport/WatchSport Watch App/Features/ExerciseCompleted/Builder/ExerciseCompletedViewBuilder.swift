//
//  ExerciseCompletedViewBuilder.swift
//  WatchSport
//

enum ExerciseCompletedViewBuilder {

    @MainActor
    static func build(
        route: ExerciseCompletedRoute,
        onDone: @escaping () -> Void = {}
    ) -> ExerciseCompletedView {
        let viewModel = ExerciseCompletedViewModel(
            exerciseType: route.exerciseType,
            completedAmount: route.completedAmount
        )

        return ExerciseCompletedView(viewModel: viewModel, onDone: onDone)
    }
}
