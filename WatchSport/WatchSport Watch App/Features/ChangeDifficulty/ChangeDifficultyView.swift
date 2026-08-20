//
//  ChangeDifficultyView.swift
//  WatchSport
//

import SwiftData
import SwiftUI

struct ChangeDifficultyView: View {
    @Environment(\.dismiss) private var dismiss
    @Query private var dailyChallengeList: [DailyChallenge]
    @State var viewModel: ChangeDifficultyViewModel
    @State private var isShowingProgressWarning = false

    @AppStorage(UserDefaultsKey.selectedChallengeDifficulty)
    private var savedDifficulty: ChallengeDifficulty = .medium

    var body: some View {
        ZStack {
            Color.backgroundDefault
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 14) {
                    VStack(spacing: 4) {
                        Text("Alterar nível")
                            .font(.system(size: 21, weight: .bold))
                            .foregroundStyle(Color.textPrimary)
                            .multilineTextAlignment(.center)

                        Text("O novo nível será aplicado ao desafio de hoje.")
                            .font(.system(size: 12))
                            .foregroundStyle(Color.textSecondary)
                            .multilineTextAlignment(.center)
                    }

                    VStack(spacing: 8) {
                        ForEach(ChallengeDifficulty.allCases, id: \.self) { difficulty in
                            DifficultyOptionButton(
                                difficulty: difficulty,
                                isSelected: viewModel.selectedDifficulty == difficulty,
                                action: {
                                    viewModel.selectedDifficulty = difficulty
                                }
                            )
                        }
                    }

                    if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .font(.system(size: 12))
                            .foregroundStyle(Color.warning)
                            .multilineTextAlignment(.center)
                    }

                    AppButton(
                        title: "Salvar nível",
                        variant: .light,
                        action: requestSave
                    )
                    .disabled(viewModel.isSaving)
                }
                .padding(.horizontal, 8)
                .padding(.bottom, 8)
            }
        }
        .alert("Perder progresso de hoje?", isPresented: $isShowingProgressWarning) {
            Button("Cancelar", role: .cancel) {}
            Button("Alterar nível", role: .destructive) {
                saveAndDismiss()
            }
        } message: {
            Text("Você já fez exercício no desafio de hoje. Ao mudar o nível, todo o progresso de hoje será perdido.")
        }
    }
}

extension ChangeDifficultyView {
    private func requestSave() {
        guard viewModel.selectedDifficulty != savedDifficulty else {
            dismiss()
            return
        }

        if viewModel.hasProgressToday(in: dailyChallengeList) {
            isShowingProgressWarning = true
        } else {
            saveAndDismiss()
        }
    }

    private func saveAndDismiss() {
        guard viewModel.save(dailyChallengeList: dailyChallengeList) else { return }

        savedDifficulty = viewModel.selectedDifficulty
        dismiss()
    }
}

#Preview {
    struct PreviewWithContextWrapper: View {
        @Environment(\.modelContext) private var context

        var body: some View {
            NavigationStack {
                ChangeDifficultyViewBuilder.build(
                    context: context,
                    selectedDifficulty: .medium
                )
            }
        }
    }

    return PreviewWithContextWrapper()
        .modelContainer(for: [DailyChallenge.self, DailyExercise.self], inMemory: true)
}
