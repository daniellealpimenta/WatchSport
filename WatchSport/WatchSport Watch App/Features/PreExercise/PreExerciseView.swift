//
//  PreExerciseView.swift
//  WatchSport
//

import SwiftData
import SwiftUI

struct PreExerciseView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var activeExerciseRoute: ActiveExerciseRoute?
    @State private var isCompleted = false

    let viewModel: PreExerciseViewModel

    let onStart: () -> Void

    var body: some View {
        ZStack {
            Color.backgroundDefault
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 8) {

                    VStack(spacing: 4) {
                        Text(viewModel.title)
                            .font(.system(size: 13, weight: .regular))
                            .foregroundStyle(Color.textSecondary)
                            .multilineTextAlignment(.center)

                        Image(systemName: viewModel.exerciseType.systemImageName)
                            .font(.system(size: 34, weight: .medium))
                            .foregroundStyle(Color.brandPurple)
                            .frame(width: 56, height: 56)
                            .background(Color.surface)
                            .clipShape(Circle())
                            .overlay {
                                Circle()
                                    .stroke(Color.brandPurple.opacity(0.3), lineWidth: 1)
                            }
                            .accessibilityHidden(true)

                    }

                    VStack(spacing: 4) {
                        Text(viewModel.targetDescription)
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundStyle(Color.textPrimary)
                            .lineLimit(1)
                            .minimumScaleFactor(0.7)

                        Text("Sua meta de hoje")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundStyle(Color.brandPurple)
                    }

                    Text(viewModel.instructions)
                        .font(.system(size: 13, weight: .regular))
                        .foregroundStyle(Color.textSecondary)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)

                    AppButton(
                        title: isCompleted ? "Concluído" : "Iniciar",
                        variant: .gradient,
                        action: startExercise
                    )
                    .disabled(isCompleted)
                }
                .padding(.horizontal, 8)
                .padding(.bottom, 8)
            }
        }
        .navigationDestination(item: $activeExerciseRoute) { route in
            ActiveExerciseViewBuilder.build(
                route: route,
                modelContext: modelContext,
                onCompleted: {
                    isCompleted = true
                }
            )
        }
    }

    private func startExercise() {
        onStart()
        activeExerciseRoute = ActiveExerciseRoute(
            exerciseID: viewModel.exerciseID,
            exerciseType: viewModel.exerciseType,
            targetAmount: viewModel.targetAmount
        )
    }
}



#Preview {
    NavigationStack {
        PreExerciseViewBuilder.build(
            route: PreExerciseRoute(
                exerciseID: DailyExercise(exerciseType: .squat, targetAmount: 20).persistentModelID,
                exerciseType: .squat,
                targetAmount: 20
            )
        )
    }
    .modelContainer(for: [DailyChallenge.self, DailyExercise.self], inMemory: true)
}
