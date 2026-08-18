//
//  ChallengeTargets.swift
//  WatchSport
//

import Foundation

struct ExerciseTarget: Identifiable {
    let exerciseType: ExerciseType
    let amount: Double

    var id: ExerciseType { exerciseType }
}

enum ChallengeTargets {
    static func exercises(for difficulty: ChallengeDifficulty) -> [ExerciseTarget] {
        switch difficulty {
        case .easy:
            return makeTargets(pushUps: 5, sitUps: 10, squats: 10, runningMeters: 500)
        case .medium:
            return makeTargets(pushUps: 10, sitUps: 20, squats: 20, runningMeters: 1_500)
        case .hard:
            return makeTargets(pushUps: 20, sitUps: 40, squats: 40, runningMeters: 3_000)
        }
    }

    private static func makeTargets(
        pushUps: Double,
        sitUps: Double,
        squats: Double,
        runningMeters: Double
    ) -> [ExerciseTarget] {
        [
            ExerciseTarget(exerciseType: .pushUp, amount: pushUps),
            ExerciseTarget(exerciseType: .sitUp, amount: sitUps),
            ExerciseTarget(exerciseType: .squat, amount: squats),
            ExerciseTarget(exerciseType: .running, amount: runningMeters)
        ]
    }
}
