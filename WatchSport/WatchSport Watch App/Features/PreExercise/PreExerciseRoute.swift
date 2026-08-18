//
//  PreExerciseRoute.swift
//  WatchSport
//

import SwiftData

struct PreExerciseRoute: Hashable {
    let exerciseID: PersistentIdentifier
    let exerciseType: ExerciseType
    let targetAmount: Double
}
