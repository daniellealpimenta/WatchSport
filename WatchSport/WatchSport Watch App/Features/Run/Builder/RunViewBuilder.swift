//
//  RunViewBuilder.swift
//  WatchSport
//

import SwiftData

enum RunViewBuilder {

    @MainActor
    static func build(
        route: RunRoute,
        context: ModelContext,
        onFinish: @escaping (Double) -> Void = { _ in }
    ) -> RunView {
        #if targetEnvironment(simulator)
        let tracker: RunTracking = SimulatedRunTracking()
        #else
        let tracker: RunTracking = HealthKitRunTracking()
        #endif

        let viewModel = RunViewModel(
            exerciseID: route.exerciseID,
            targetMeters: route.targetMeters,
            tracker: tracker,
            dailyChallengeService: DailyChallengeService(modelContext: context)
        )

        return RunView(viewModel: viewModel, onFinish: onFinish)
    }
}
