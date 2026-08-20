//
//  ActiveExerciseRoute.swift
//  WatchSport
//

import SwiftData

struct ActiveExerciseRoute: Hashable {
    let exerciseID: PersistentIdentifier?
    let exerciseType: ExerciseType
    let targetRepetitions: Int

    init?(
        exerciseID: PersistentIdentifier? = nil,
        exerciseType: ExerciseType,
        targetAmount: Double
    ) {
        guard exerciseType != .running else { return nil }

        self.exerciseID = exerciseID
        self.exerciseType = exerciseType
        self.targetRepetitions = max(Int(targetAmount.rounded()), 1)
    }
}
