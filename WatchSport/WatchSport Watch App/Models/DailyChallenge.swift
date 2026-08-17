//
//  DailyChallenge.swift
//  WatchSport
//

import Foundation
import SwiftData

@Model
final class DailyChallenge {
    @Attribute(.unique) var day: Date
    var difficulty: ChallengeDifficulty
    var completedAt: Date?

    @Relationship(deleteRule: .cascade, inverse: \DailyExercise.challenge)
    var exercises: [DailyExercise]

    var isCompleted: Bool {
        completedAt != nil
    }

    init(
        day: Date,
        difficulty: ChallengeDifficulty,
        exercises: [DailyExercise] = [],
        completedAt: Date? = nil
    ) {
        self.day = Calendar.current.startOfDay(for: day)
        self.difficulty = difficulty
        self.exercises = exercises
        self.completedAt = completedAt
    }
}
