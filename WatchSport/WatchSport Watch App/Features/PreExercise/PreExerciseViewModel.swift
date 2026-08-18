//
//  PreExerciseViewModel.swift
//  WatchSport
//

import SwiftData

struct PreExerciseViewModel {
    let exerciseID: PersistentIdentifier?
    let exerciseType: ExerciseType
    let targetAmount: Double

    init(
        exerciseID: PersistentIdentifier?,
        exerciseType: ExerciseType,
        targetAmount: Double
    ) {
        self.exerciseID = exerciseID
        self.exerciseType = exerciseType
        self.targetAmount = targetAmount
    }

    var title: String {
        exerciseType.displayName
    }

    var targetDescription: String {
        switch exerciseType.measurementUnit {
        case .repetitions:
            let repetitions = ExerciseAmountFormatter.repetitions(targetAmount)
            let unit = targetAmount == 1 ? "repetição" : "repetições"
            return "\(repetitions) \(unit)"
        case .meters:
            return ExerciseAmountFormatter.distance(targetAmount)
        }
    }

    var instructions: String {
        switch exerciseType {
        case .running:
            "Ao iniciar, o Watch acompanhará sua distância automaticamente."
        case .pushUp, .sitUp, .squat:
            "Ao iniciar, o Watch fará uma contagem regressiva e começará a contar automaticamente."
        }
    }
}
