//
//  ExerciseCompletedView.swift
//  WatchSport
//

import SwiftUI

struct ExerciseCompletedView: View {
    let viewModel: ExerciseCompletedViewModel

    let onDone: () -> Void

    var body: some View {
        ZStack {
            Color.backgroundDefault
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 8) {
                    CompletionBadge()

                    VStack(spacing: 2) {
                        Text(viewModel.title)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundStyle(Color.textPrimary)
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                            .minimumScaleFactor(0.8)

                        Text(viewModel.resultDescription)
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .foregroundStyle(Color.brandPurple)
                            .lineLimit(1)
                            .minimumScaleFactor(0.7)

                        Text("Missão atualizada")
                            .font(.system(size: 12, weight: .regular))
                            .foregroundStyle(Color.textSecondary)
                    }

                    AppButton(
                        title: "Voltar à missão",
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
        ExerciseCompletedViewBuilder.build(
            route: ExerciseCompletedRoute(exerciseType: .running, completedAmount: 1_500)
        )
    }
}
