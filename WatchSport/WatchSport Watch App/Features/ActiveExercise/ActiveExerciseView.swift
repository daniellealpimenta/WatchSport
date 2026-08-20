//
//  ActiveExerciseView.swift
//  WatchSport
//

import SwiftUI
import SwiftData

struct ActiveExerciseView: View {
    @State var viewModel: ActiveExerciseViewModel

    var body: some View {
        ZStack {
            Color.backgroundDefault
                .ignoresSafeArea()

            if viewModel.hasError {
                ErrorStateView(message: viewModel.errorMessage)
            } else if let countdownValue = viewModel.countdownValue {
                ExerciseCountdownView(value: countdownValue)
                    .id(countdownValue)
                    .transition(ExerciseCountdownView.transition)
            } else {
                exerciseContent
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: viewModel.countdownValue)
        .navigationBarBackButtonHidden(!viewModel.hasError && !viewModel.isCompleted)
        .task {
            await viewModel.start()
        }
        .onDisappear {
            viewModel.stop()
        }
    }
}

extension ActiveExerciseView {
    private var exerciseContent: some View {
        VStack(spacing: 0) {
            Text(viewModel.title)
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(Color.textSecondary)
                .lineLimit(1)

            Spacer()

            VStack(spacing: 5) {
                Text("\(viewModel.displayedCount)")
                    .font(.system(size: 82, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.textPrimary)
                    .monospacedDigit()
                    .contentTransition(.numericText())
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)

                Text(viewModel.countDescription)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(Color.textSecondary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)

                Text(viewModel.statusDescription)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundStyle(Color.brandPurple)
                    .contentTransition(.numericText())
            }
            .animation(
                .easeInOut(duration: 0.25),
                value: viewModel.completedRepetitions
            )

            Spacer()

            VStack(spacing: 8) {
                ExerciseProgressBar(progress: viewModel.progress)

                Text(viewModel.isCompleted ? "Exercício concluído" : "Continue até concluir a meta")
                    .font(.system(size: 11, weight: .regular))
                    .foregroundStyle(Color.textSecondary.opacity(0.7))
                    .multilineTextAlignment(.center)
            }
        }
        .padding(.horizontal, 8)
        .padding(.bottom, 8)
    }
}

#Preview {
    struct PreviewWrapper: View {
        @Environment(\.modelContext) private var modelContext

        var body: some View {
            NavigationStack {
                ActiveExerciseViewBuilder.build(
                    route: ActiveExerciseRoute(
                        exerciseType: .squat,
                        targetAmount: 20
                    )!,
                    modelContext: modelContext
                )
            }
        }
    }

    return PreviewWrapper()
        .modelContainer(for: [DailyChallenge.self, DailyExercise.self], inMemory: true)
}
