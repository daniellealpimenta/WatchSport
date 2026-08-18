//
//  RunView.swift
//  WatchSport
//

import SwiftData
import SwiftUI

struct RunView: View {
    @State var viewModel: RunViewModel

    let onFinish: (Double) -> Void

    var body: some View {
        ZStack {
            Color.backgroundDefault
                .ignoresSafeArea()

            if let errorMessage = viewModel.errorMessage {
                ErrorStateView(message: errorMessage)
            } else {
                content
            }
        }
        .navigationBarBackButtonHidden(viewModel.finishedMeters != nil)
        .task {
            await viewModel.start()
        }
        .onDisappear {
            viewModel.stop()
        }
        .onChange(of: viewModel.finishedMeters) { _, finishedMeters in
            guard let finishedMeters else { return }
            onFinish(finishedMeters)
        }
    }

    private var content: some View {
        VStack(spacing: 8) {
            Text(ExerciseType.running.displayName)
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(Color.textSecondary)

            VStack(spacing: 2) {
                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text(viewModel.distanceDescription)
                        .font(.system(size: 34, weight: .bold, design: .rounded))
                        .foregroundStyle(Color.textPrimary)
                        .monospacedDigit()
                        .lineLimit(1)
                        .minimumScaleFactor(0.6)

                    Text("km")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(Color.textSecondary)
                }

                Text(viewModel.targetDescription)
                    .font(.system(size: 13, weight: .regular))
                    .foregroundStyle(Color.textSecondary)
            }

            ProgressView(value: viewModel.progress)
                .progressViewStyle(.linear)
                .tint(Color.brandPurple)

            HStack(spacing: 8) {
                metric(title: "Tempo") {
                    if let startDate = viewModel.startDate {
                        Text(
                            timerInterval: startDate...Date.distantFuture,
                            countsDown: false,
                            showsHours: false
                        )
                    } else {
                        Text("--:--")
                    }
                }

                metric(title: "Restante") {
                    Text("\(viewModel.remainingDescription)")
                }
            }

            Text("Continue até atingir a distância")
                .font(.system(size: 12, weight: .regular))
                .foregroundStyle(Color.textSecondary)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.horizontal, 8)
        .accessibilityElement(children: .contain)
    }

    private func metric<Value: View>(
        title: String,
        @ViewBuilder value: () -> Value
    ) -> some View {
        VStack(spacing: 2) {
            Text(title)
                .font(.system(size: 11, weight: .regular))
                .foregroundStyle(Color.textSecondary)

            value()
                .font(.system(size: 15, weight: .bold, design: .rounded))
                .foregroundStyle(Color.textPrimary)
                .monospacedDigit()
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
        .frame(maxWidth: .infinity, minHeight: 44)
        .background(Color.surface)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    struct PreviewWithContextWrapper: View {
        @Environment(\.modelContext) private var context

        var body: some View {
            let exercise = DailyExercise(exerciseType: .running, targetAmount: 1_500)
            context.insert(exercise)

            return NavigationStack {
                RunViewBuilder.build(
                    route: RunRoute(
                        exerciseID: exercise.persistentModelID,
                        targetMeters: 1_500
                    ),
                    context: context
                )
            }
        }
    }

    return PreviewWithContextWrapper()
        .modelContainer(for: [DailyChallenge.self, DailyExercise.self], inMemory: true)
}
