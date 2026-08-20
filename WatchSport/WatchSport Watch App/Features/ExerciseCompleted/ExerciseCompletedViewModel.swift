//
//  ExerciseCompletedViewModel.swift
//  WatchSport
//

struct ExerciseCompletedViewModel {
    let exerciseType: ExerciseType
    let completedAmount: Double

    var title: String {
        switch exerciseType {
        case .running, .pushUp:
            "\(exerciseType.displayName) concluída"
        case .sitUp, .squat:
            "\(exerciseType.displayName) concluído"
        }
    }

    var resultDescription: String {
        switch exerciseType.measurementUnit {
        case .repetitions:
            let repetitions = ExerciseAmountFormatter.repetitions(completedAmount)
            let unit = completedAmount == 1 ? "repetição" : "repetições"
            return "\(repetitions) \(unit)"
        case .meters:
            return ExerciseAmountFormatter.distance(completedAmount)
        }
    }
}
