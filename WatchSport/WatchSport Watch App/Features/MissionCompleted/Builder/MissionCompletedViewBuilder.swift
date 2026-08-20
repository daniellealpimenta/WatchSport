//
//  MissionCompletedViewBuilder.swift
//  WatchSport
//

enum MissionCompletedViewBuilder {

    @MainActor
    static func build(
        route: MissionCompletedRoute,
        onDone: @escaping () -> Void = {}
    ) -> MissionCompletedView {
        let viewModel = MissionCompletedViewModel(
            summary: route.summary,
            streakDays: route.streakDays
        )

        return MissionCompletedView(viewModel: viewModel, onDone: onDone)
    }
}
