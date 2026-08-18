//
//  ExerciseCompletionService.swift
//  WatchSport
//

import Foundation
import SwiftData

@MainActor
struct ExerciseCompletionService {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func complete(
        exerciseID: PersistentIdentifier,
        completedAmount: Double,
        at date: Date = .now
    ) throws {
        guard let exercise = modelContext.model(for: exerciseID) as? DailyExercise else {
            throw ExerciseCompletionError.exerciseNotFound
        }

        guard !exercise.isCompleted else { return }

        exercise.completedAmount = completedAmount
        exercise.completedAt = date

        if let challenge = exercise.challenge,
           challenge.exercises.allSatisfy(\.isCompleted) {
            challenge.completedAt = date
        }

        do {
            try modelContext.save()
        } catch {
            modelContext.rollback()
            throw error
        }
    }
}

enum ExerciseCompletionError: Error {
    case exerciseNotFound
}
