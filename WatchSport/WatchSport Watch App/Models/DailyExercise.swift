//
//  DailyExercise.swift
//  WatchSport
//

import Foundation
import SwiftData

@Model
final class DailyExercise {
    var exerciseType: ExerciseType
    var targetAmount: Double
    var completedAmount: Double?
    var completedAt: Date?

    var challenge: DailyChallenge?

    var measurementUnit: ExerciseMeasurementUnit {
        exerciseType.measurementUnit
    }

    var isCompleted: Bool {
        completedAt != nil
    }

    init(
        exerciseType: ExerciseType,
        targetAmount: Double,
        completedAmount: Double? = nil,
        completedAt: Date? = nil
    ) {
        self.exerciseType = exerciseType
        self.targetAmount = targetAmount
        self.completedAmount = completedAmount
        self.completedAt = completedAt
    }
}
