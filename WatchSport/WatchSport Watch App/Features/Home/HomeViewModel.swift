//
//  HomeViewModel.swift
//  WatchSport
//
//  Created by Lizandra Malta on 17/08/26.
//

import SwiftUI

@Observable
final class HomeViewModel {
    private let dailyChallengeService: DailyChallengeService

    private var hasPreparedDailyChallenge = false
    private(set) var isLoading = true
    private(set) var hasError = false
    private(set) var errorMessage = ""

    init(dailyChallengeService: DailyChallengeService) {
        self.dailyChallengeService = dailyChallengeService
    }

    func prepareDailyChallenge(dailyChallengeList: [DailyChallenge]) {
        guard !hasPreparedDailyChallenge else { return }
        hasPreparedDailyChallenge = true
        isLoading = true
        hasError = false
        errorMessage = ""

        defer {
            isLoading = false
        }

        do {
            try dailyChallengeService.createDailyChallengeIfNeeded(
                dailyChallengeList: dailyChallengeList
            )
        } catch {
            hasPreparedDailyChallenge = false
            hasError = true
            errorMessage = "Não foi possível carregar o desafio diário."
        }
    }
}
