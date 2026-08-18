//
//  HomeViewBuilder.swift
//  WatchSport
//
//  Created by Lizandra Malta on 18/08/26.
//

import SwiftData

enum HomeViewBuilder {

    @MainActor
    static func build(context: ModelContext) -> HomeView {

        let dailyChallengeService = DailyChallengeService(modelContext: context)

        let viewModel = HomeViewModel(dailyChallengeService: dailyChallengeService)

        return HomeView(viewModel: viewModel)

    }
}
