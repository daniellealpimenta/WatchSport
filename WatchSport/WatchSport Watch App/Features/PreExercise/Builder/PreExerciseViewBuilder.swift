//
//  PreExerciseViewBuilder.swift
//  WatchSport
//

enum PreExerciseViewBuilder {

    @MainActor
    static func build(route: PreExerciseRoute, onStart: @escaping () -> Void = {}) -> PreExerciseView {
        let viewModel = PreExerciseViewModel(
            exerciseType: route.exerciseType,
            targetAmount: route.targetAmount
        )

        return PreExerciseView(
            viewModel: viewModel,
            onStart: onStart
        )
    }
}
