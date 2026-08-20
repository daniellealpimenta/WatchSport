//
//  ExerciseType+Tracker.swift
//  WatchSport
//

import ExercisesPackage

extension ExerciseType {
    var trackerType: ExercisesPackage.ExerciseType? {
        switch self {
        case .pushUp:
            .pushUp
        case .sitUp:
            .sitUp
        case .squat:
            .squat
        case .running:
            nil
        }
    }
}
