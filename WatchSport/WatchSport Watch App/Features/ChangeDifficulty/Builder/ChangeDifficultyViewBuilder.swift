//
//  ChangeDifficultyViewBuilder.swift
//  WatchSport
//

import SwiftData

enum ChangeDifficultyViewBuilder {
    @MainActor
    static func build(
        context: ModelContext,
        selectedDifficulty: ChallengeDifficulty
    ) -> ChangeDifficultyView {
        let service = DailyChallengeService(modelContext: context)
        let viewModel = ChangeDifficultyViewModel(
            selectedDifficulty: selectedDifficulty,
            dailyChallengeService: service
        )

        return ChangeDifficultyView(viewModel: viewModel)
    }
}
