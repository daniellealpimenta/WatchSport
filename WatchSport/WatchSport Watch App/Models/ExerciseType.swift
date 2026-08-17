//
//  ExerciseType.swift
//  WatchSport
//

import Foundation

enum ExerciseType: String, Codable, CaseIterable {
    case pushUp
    case sitUp
    case squat
    case running

    var measurementUnit: ExerciseMeasurementUnit {
        switch self {
        case .pushUp, .sitUp, .squat:
            .repetitions
        case .running:
            .meters
        }
    }
}

enum ExerciseMeasurementUnit: String, Codable {
    case repetitions
    case meters
}
