//
//  ChangeDifficultyViewModel.swift
//  WatchSport
//

import Foundation
import SwiftUI

@Observable
final class ChangeDifficultyViewModel {
    private let dailyChallengeService: DailyChallengeService

    var selectedDifficulty: ChallengeDifficulty
    private(set) var isSaving = false
    private(set) var errorMessage: String?

    init(
        selectedDifficulty: ChallengeDifficulty,
        dailyChallengeService: DailyChallengeService
    ) {
        self.selectedDifficulty = selectedDifficulty
        self.dailyChallengeService = dailyChallengeService
    }

    func hasProgressToday(
        in dailyChallengeList: [DailyChallenge],
        date: Date = .now,
        calendar: Calendar = .current
    ) -> Bool {
        guard let challenge = challenge(
            for: date,
            in: dailyChallengeList,
            calendar: calendar
        ) else {
            return false
        }

        return challenge.exercises.contains { exercise in
            exercise.isCompleted || exercise.completedAmount != nil
        }
    }

    func save(
        dailyChallengeList: [DailyChallenge],
        date: Date = .now,
        calendar: Calendar = .current
    ) -> Bool {
        isSaving = true
        errorMessage = nil

        defer {
            isSaving = false
        }

        do {
            try dailyChallengeService.changeDifficulty(
                to: selectedDifficulty,
                dailyChallengeList: dailyChallengeList,
                for: date,
                calendar: calendar
            )
            return true
        } catch {
            errorMessage = "Não foi possível alterar o nível. Tente novamente."
            return false
        }
    }

    private func challenge(
        for date: Date,
        in dailyChallengeList: [DailyChallenge],
        calendar: Calendar
    ) -> DailyChallenge? {
        dailyChallengeList.first { challenge in
            calendar.isDate(challenge.day, inSameDayAs: date)
        }
    }
}
