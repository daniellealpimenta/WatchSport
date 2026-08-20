//
//  MissionCompletedViewModel.swift
//  WatchSport
//

struct MissionCompletedViewModel {
    let summary: [ExerciseSummary]
    let streakDays: Int

    var title: String {
        "Missão concluída"
    }

    var resultDescription: String {
        let total = summary.count
        let unit = total == 1 ? "exercício" : "exercícios"
        return "\(total) de \(total) \(unit) · 100%"
    }

    var streakDescription: String {
        streakDays == 1
            ? "Sequência de 1 dia"
            : "Sequência de \(streakDays) dias"
    }

    var showsStreak: Bool {
        streakDays > 0
    }

    var doneTitle: String {
        "Concluir"
    }

    func amountDescription(for exercise: ExerciseSummary) -> String {
        switch exercise.exerciseType.measurementUnit {
        case .repetitions:
            ExerciseAmountFormatter.repetitions(exercise.completedAmount)
        case .meters:
            ExerciseAmountFormatter.distance(exercise.completedAmount)
        }
    }
}
