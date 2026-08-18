//
//  DailyChallengeService.swift
//  WatchSport
//

import Foundation
import SwiftData

@MainActor
struct DailyChallengeService {

    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func createDailyChallengeIfNeeded(
        dailyChallengeList: [DailyChallenge],
        difficulty: ChallengeDifficulty = .medium,
        for date: Date = .now,
        calendar: Calendar = .current
    ) throws {
        let startOfDay = calendar.startOfDay(for: date)

        if dailyChallengeList.contains(where: { $0.day == startOfDay }) {
            return
        }

        let exercises = ChallengeTargets.exercises(for: difficulty).map { target in
            DailyExercise(
                exerciseType: target.exerciseType,
                targetAmount: target.amount
            )
        }

        let challenge = DailyChallenge(
            day: startOfDay,
            difficulty: difficulty,
            exercises: exercises
        )

        modelContext.insert(challenge)

        do {
            try modelContext.save()
        } catch {
            modelContext.rollback()
            throw error
        }
    }
}
