//
//  HomeView.swift
//  WatchSport
//
//  Created by Lizandra Malta on 17/08/26.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @State var viewModel: HomeViewModel
    @Query private var dailyChallengeList: [DailyChallenge]

    private let difficulty = ChallengeDifficulty.medium

    private var targets: [ExerciseTarget] {
        ChallengeTargets.exercises(for: difficulty)
    }

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
            } else {
                content
            }
        }
        .task {
            viewModel.prepareDailyChallenge(dailyChallengeList: dailyChallengeList)
        }
    }

    @ViewBuilder
    private var content: some View {
            ScrollView {
                VStack(spacing: 10) {
                    HStack {
                        Text("MISSÃO DIÁRIA")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundStyle(Color.textSecondary)
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)

                        Spacer()

                        StreakBadge(dayCount: 7)
                            .layoutPriority(1)
                    }

                    ProgressRingView(completedCount: 3, totalCount: targets.count)

                    ForEach(Array(targets.enumerated()), id: \.element.id) { index, target in
                        ExerciseRowButton(
                            exerciseType: target.exerciseType,
                            completedAmount: index == 2 ? 0 : target.amount,
                            targetAmount: target.amount,
                            isCompleted: index != 2,
                            action: {}
                        )
                    }
                }
                .padding(.horizontal, 8)
                .padding(.bottom, 8)
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
