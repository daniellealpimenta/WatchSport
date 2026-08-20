//
//  HomeView.swift
//  WatchSport
//
//  Created by Lizandra Malta on 17/08/26.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @State var viewModel: HomeViewModel
    @State private var preExerciseRoute: PreExerciseRoute?
    @State private var runRoute: RunRoute?
    @State private var exerciseCompletedRoute: ExerciseCompletedRoute?
    @State private var isChangingDifficulty = false
    @Query private var dailyChallengeList: [DailyChallenge]

    @AppStorage(UserDefaultsKey.selectedChallengeDifficulty)
    private var selectedDifficulty: ChallengeDifficulty = .medium

    var body: some View {
        ZStack {
            Color.backgroundDefault
                .ignoresSafeArea()

            if viewModel.isLoading {
                ProgressView()
                    .controlSize(.large)
                    .tint(Color.brandPurple)
                    .accessibilityLabel("Carregando desafio diário")
            } else if viewModel.hasError {
                ErrorStateView(message: viewModel.errorMessage)
            } else if let dailyChallenge {
                content(for: dailyChallenge)
            } else {
                ErrorStateView(message: "Não encontramos o desafio de hoje.")
            }
        }
        .task {
            viewModel.prepareDailyChallenge(
                dailyChallengeList: dailyChallengeList,
                difficulty: selectedDifficulty
            )
        }
        .navigationDestination(item: $preExerciseRoute) { route in
            PreExerciseViewBuilder.build(route: route, onStart: { start(route) })
        }
        .navigationDestination(item: $runRoute) { route in
            RunViewBuilder.build(
                route: route,
                context: modelContext,
                onFinish: { completedMeters in
                    exerciseCompletedRoute = ExerciseCompletedRoute(
                        exerciseType: .running,
                        completedAmount: completedMeters
                    )
                },
                onCancel: backToChallenge
            )
        }
        .navigationDestination(item: $exerciseCompletedRoute) { route in
            ExerciseCompletedViewBuilder.build(route: route, onDone: backToChallenge)
        }
        .navigationDestination(isPresented: $isChangingDifficulty) {
            ChangeDifficultyViewBuilder.build(
                context: modelContext,
                selectedDifficulty: selectedDifficulty
            )
        }
    }

    private var dailyChallenge: DailyChallenge? {
        viewModel.dailyChallenge(in: dailyChallengeList)
    }

    private var streak: Int {
        viewModel.currentStreak(in: dailyChallengeList)
    }

    private func content(for challenge: DailyChallenge) -> some View {
        let exercises = sortedExercises(from: challenge)
        let completedCount = exercises.filter(\.isCompleted).count

        return ScrollView {
            VStack(spacing: 16) {
                HStack {
                    Text("MISSÃO DIÁRIA")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundStyle(Color.textSecondary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)

                    Spacer()

                    StreakBadge(dayCount: streak)
                        .layoutPriority(1)
                }

                ProgressRingView(
                    completedCount: completedCount,
                    totalCount: exercises.count
                )

                Text("\(challenge.difficulty.displayName) • \(completedCount) de \(exercises.count)")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(Color.textSecondary)
                    .multilineTextAlignment(.center)

                VStack(spacing: 8) {
                    ForEach(exercises, id: \.exerciseType) { exercise in
                        ExerciseRowButton(
                            exerciseType: exercise.exerciseType,
                            completedAmount: exercise.completedAmount ?? 0,
                            targetAmount: exercise.targetAmount,
                            isCompleted: exercise.isCompleted,
                            action: {
                                guard !exercise.isCompleted else { return }

                                preExerciseRoute = PreExerciseRoute(
                                    exerciseID: exercise.persistentModelID,
                                    exerciseType: exercise.exerciseType,
                                    targetAmount: exercise.targetAmount
                                )
                            }
                        )
                    }
                }


                AppButton(
                    title: "Alterar nível",
                    variant: .dark,
                    action: {
                        isChangingDifficulty = true
                    }
                )
            }
            .padding(.horizontal, 8)
            .padding(.bottom, 8)
        }
    }

    private func start(_ route: PreExerciseRoute) {
        // Somente a corrida está implementada; os exercícios de repetição virão depois.
        guard route.exerciseType == .running else { return }

        runRoute = RunRoute(
            exerciseID: route.exerciseID,
            targetMeters: route.targetAmount
        )
    }

    private func backToChallenge() {
        exerciseCompletedRoute = nil
        runRoute = nil
        preExerciseRoute = nil
    }

    private func sortedExercises(from challenge: DailyChallenge) -> [DailyExercise] {
        challenge.exercises.sorted { lhs, rhs in
            let lhsIndex = ExerciseType.allCases.firstIndex(of: lhs.exerciseType) ?? 0
            let rhsIndex = ExerciseType.allCases.firstIndex(of: rhs.exerciseType) ?? 0
            return lhsIndex < rhsIndex
        }
    }
}

#Preview {
    struct PreviewWithContextWrapper: View {
        @Environment(\.modelContext) private var context

        var body: some View {
            HomeViewBuilder.build(context: context)
        }
    }

    return PreviewWithContextWrapper()
        .modelContainer(for: [DailyChallenge.self, DailyExercise.self], inMemory: true)
}
