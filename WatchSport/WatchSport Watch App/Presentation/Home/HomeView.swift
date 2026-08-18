//
//  HomeView.swift
//  WatchSport
//
//  Created by Lizandra Malta on 17/08/26.
//

import SwiftUI

struct HomeView: View {
    private let difficulty = ChallengeDifficulty.medium

    private var targets: [ExerciseTarget] {
        ChallengeTargets.exercises(for: difficulty)
    }

    var body: some View {
        ZStack {
            Color.backgroundDefault
                .ignoresSafeArea()

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
                .padding(.vertical, 10)
            }
        }
    }
}

#Preview {
    HomeView()
}
