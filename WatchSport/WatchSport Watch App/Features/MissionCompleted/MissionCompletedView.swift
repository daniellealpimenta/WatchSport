//
//  MissionCompletedView.swift
//  WatchSport
//

import SwiftUI

struct MissionCompletedView: View {
    let viewModel: MissionCompletedViewModel

    let onDone: () -> Void

    var body: some View {
        ZStack {
            Color.backgroundDefault
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 8) {
                    CompletionBadge()

                    VStack(spacing: 6) {
                        Text(viewModel.title)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundStyle(Color.textPrimary)
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                            .minimumScaleFactor(0.8)

                        Text(viewModel.resultDescription)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(Color.textSecondary)
                            .multilineTextAlignment(.center)
                            .lineLimit(1)
                            .minimumScaleFactor(0.7)

                        if viewModel.showsStreak {
                            MissionStreakPill(description: viewModel.streakDescription)
                        }
                    }

                    VStack(spacing: 6) {
                        ForEach(viewModel.summary, id: \.exerciseType) { exercise in
                            MissionSummaryRow(
                                title: exercise.exerciseType.displayName,
                                amountDescription: viewModel.amountDescription(for: exercise)
                            )
                        }
                    }

                    AppButton(
                        title: viewModel.doneTitle,
                        variant: .gradient,
                        action: onDone
                    )
                }
                .padding(.horizontal, 8)
                .padding(.bottom, 8)
            }
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    NavigationStack {
        MissionCompletedViewBuilder.build(
            route: MissionCompletedRoute(
                summary: [
                    ExerciseSummary(exerciseType: .pushUp, completedAmount: 10),
                    ExerciseSummary(exerciseType: .sitUp, completedAmount: 20),
                    ExerciseSummary(exerciseType: .squat, completedAmount: 20),
                    ExerciseSummary(exerciseType: .running, completedAmount: 1_500)
                ],
                streakDays: 8
            )
        )
    }
}
