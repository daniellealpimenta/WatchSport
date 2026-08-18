//
//  HomeViewModel.swift
//  WatchSport
//
//  Created by Lizandra Malta on 17/08/26.
//

import Foundation
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

    func prepareDailyChallenge(
        dailyChallengeList: [DailyChallenge],
        difficulty: ChallengeDifficulty = .medium
    ) {
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
                dailyChallengeList: dailyChallengeList,
                difficulty: difficulty
            )
        } catch {
            hasPreparedDailyChallenge = false
            hasError = true
            errorMessage = "Não foi possível carregar o desafio diário."
        }
    }

    func dailyChallenge(
        for date: Date = .now,
        in dailyChallengeList: [DailyChallenge],
        calendar: Calendar = .current
    ) -> DailyChallenge? {
        dailyChallengeList.first { challenge in
            calendar.isDate(challenge.day, inSameDayAs: date)
        }
    }

    func currentStreak(
        in dailyChallengeList: [DailyChallenge],
        through date: Date = .now,
        calendar: Calendar = .current
    ) -> Int {
        let completedDays = Set(
            dailyChallengeList
                .filter(\.isCompleted)
                .map { calendar.startOfDay(for: $0.day) }
        )

        var currentDay = calendar.startOfDay(for: date)
        if !completedDays.contains(currentDay) {
            guard let yesterday = calendar.date(byAdding: .day, value: -1, to: currentDay) else {
                return 0
            }
            currentDay = yesterday
        }

        var streak = 0
        while completedDays.contains(currentDay) {
            streak += 1
            guard let previousDay = calendar.date(byAdding: .day, value: -1, to: currentDay) else {
                break
            }
            currentDay = previousDay
        }

        return streak
    }
}
