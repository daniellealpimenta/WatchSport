//
//  OnboardingView.swift
//  WatchSport
//

import SwiftUI

struct OnboardingView: View {
    @AppStorage(UserDefaultsKey.hasCompletedOnboarding)
    private var hasCompletedOnboarding = false

    @AppStorage(UserDefaultsKey.selectedChallengeDifficulty)
    private var selectedDifficulty: ChallengeDifficulty = .medium

    var body: some View {
        ZStack {
            Color.backgroundDefault
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 14) {
                    Image(systemName: "figure.run")
                        .font(.system(size: 26, weight: .semibold))
                        .foregroundStyle(Color.backgroundDefault)
                        .frame(width: 48, height: 48)
                        .background(Color.brandPurple)
                        .clipShape(Circle())

                    VStack(spacing: 4) {
                        Text("Escolha seu nível")
                            .font(.system(size: 21, weight: .bold))
                            .foregroundStyle(Color.textPrimary)
                            .multilineTextAlignment(.center)

                        Text("Você poderá alterar essa escolha depois.")
                            .font(.system(size: 12, weight: .regular))
                            .foregroundStyle(Color.textSecondary)
                            .multilineTextAlignment(.center)
                    }

                    VStack(spacing: 8) {
                        ForEach(ChallengeDifficulty.allCases, id: \.self) { difficulty in
                            DifficultyOptionButton(
                                difficulty: difficulty,
                                isSelected: selectedDifficulty == difficulty,
                                action: {
                                    selectedDifficulty = difficulty
                                }
                            )
                        }
                    }

                    AppButton(
                        title: "Continuar",
                        variant: .light,
                        action: {
                            withAnimation(.easeInOut) {
                                hasCompletedOnboarding = true
                            }
                        }
                    )
                }
                .padding(.horizontal, 8)
                .padding(.bottom, 8)
            }
        }
    }
}

#Preview {
    OnboardingView()
}
