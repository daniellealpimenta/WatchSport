//
//  MissionCompletedRoute.swift
//  WatchSport
//

/// Resultado de um exercício do dia, já desacoplado do SwiftData para poder
/// trafegar como valor na navegação.
struct ExerciseSummary: Hashable {
    let exerciseType: ExerciseType
    let completedAmount: Double
}

struct MissionCompletedRoute: Hashable {
    let summary: [ExerciseSummary]
    let streakDays: Int
}
