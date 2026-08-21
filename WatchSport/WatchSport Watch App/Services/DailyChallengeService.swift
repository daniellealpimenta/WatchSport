//
//  DailyChallengeService.swift
//  WatchSport
//

import Foundation
import SwiftData

enum DailyChallengeServiceError: Error {
    case exerciseNotFound
}

@MainActor
struct DailyChallengeService {

    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func createDailyChallengeIfNeeded(
        dailyChallengeList: [DailyChallenge],
        difficulty: ChallengeDifficulty = .medium,
        for date: Date = .now,
        calendar: Calendar = .current
    ) throws {
        let startOfDay = calendar.startOfDay(for: date)

        if dailyChallengeList.contains(where: { $0.day == startOfDay }) {
            return
        }

        let exercises = ChallengeTargets.exercises(for: difficulty).map { target in
            DailyExercise(
                exerciseType: target.exerciseType,
                targetAmount: target.amount
            )
        }

        let challenge = DailyChallenge(
            day: startOfDay,
            difficulty: difficulty,
            exercises: exercises
        )

        modelContext.insert(challenge)

        do {
            try modelContext.save()
        } catch {
            modelContext.rollback()
            throw error
        }
    }

    func completeExercise(
        with id: PersistentIdentifier,
        completedAmount: Double,
        at date: Date = .now
    ) throws {
        guard let exercise = modelContext.model(for: id) as? DailyExercise else {
            throw DailyChallengeServiceError.exerciseNotFound
        }

        // O tracker de repetições pode emitir a meta mais de uma vez antes de parar.
        guard !exercise.isCompleted else { return }

        exercise.completedAmount = completedAmount
        exercise.completedAt = date

        if let challenge = exercise.challenge, challenge.exercises.allSatisfy(\.isCompleted) {
            challenge.completedAt = date
        }

        do {
            try modelContext.save()
        } catch {
            modelContext.rollback()
            throw error
        }
    }

    func changeDifficulty(
        to difficulty: ChallengeDifficulty,
        dailyChallengeList: [DailyChallenge],
        for date: Date = .now,
        calendar: Calendar = .current
    ) throws {
        let startOfDay = calendar.startOfDay(for: date)

        guard let challenge = dailyChallengeList.first(where: {
            calendar.isDate($0.day, inSameDayAs: startOfDay)
        }) else {
            try createDailyChallengeIfNeeded(
                dailyChallengeList: dailyChallengeList,
                difficulty: difficulty,
                for: date,
                calendar: calendar
            )
            return
        }

        guard challenge.difficulty != difficulty else { return }

        let previousExercises = challenge.exercises
        let newExercises = ChallengeTargets.exercises(for: difficulty).map { target in
            DailyExercise(
                exerciseType: target.exerciseType,
                targetAmount: target.amount
            )
        }

        challenge.difficulty = difficulty
        challenge.completedAt = nil
        challenge.exercises = newExercises
        previousExercises.forEach(modelContext.delete)

        do {
            try modelContext.save()
        } catch {
            modelContext.rollback()
            throw error
        }
    }
}
