//
//  ExerciseType.swift
//  WatchSport
//

import Foundation

enum ExerciseType: String, Codable, CaseIterable, Hashable {
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

    var displayName: String {
        switch self {
        case .pushUp:
            "Flexão"
        case .sitUp:
            "Abdominal"
        case .squat:
            "Agachamento"
        case .running:
            "Corrida"
        }
    }

    var systemImageName: String {
        switch self {
        case .pushUp:
            "dumbbell.fill"
        case .sitUp:
            "figure.core.training"
        case .squat:
            "figure.strengthtraining.traditional"
        case .running:
            "figure.run"
        }
    }
}

enum ExerciseMeasurementUnit: String, Codable {
    case repetitions
    case meters
}
