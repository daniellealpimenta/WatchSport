//
//  ExerciseRowButton.swift
//  WatchSport
//

import SwiftUI

struct ExerciseRowButton: View {
    let exerciseType: ExerciseType
    let completedAmount: Double
    let targetAmount: Double
    let isCompleted: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {

                VStack(alignment: .leading, spacing: 1) {
                    Text(title)
                        .font(.system(size: 17, weight: .bold))
                        .foregroundStyle(Color.textPrimary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)

                    Text(progressDescription)
                        .font(.system(size: 14, weight: .regular))
                        .foregroundStyle(Color.textSecondary)
                        .lineLimit(2)
                }

                Spacer(minLength: 4)

                Image(systemName: isCompleted ? "checkmark" : "chevron.right")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(isCompleted ? Color.textPrimary : Color.textSecondary)
                    .frame(width: 34, height: 34)
                    .background(isCompleted ? Color.brandPurple.opacity(0.35) : Color.white.opacity(0.06))
                    .clipShape(Circle())
            }
            .padding(.horizontal, 12)
            .frame(maxWidth: .infinity, minHeight: 68)
            .background(Color.surface)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
        .buttonStyle(.plain)
        .accessibilityLabel(title)
        .accessibilityValue(progressDescription)
        .accessibilityHint(isCompleted ? "Exercício concluído" : "Iniciar exercício")
    }
}

extension ExerciseRowButton {
    private var title: String {
        switch exerciseType {
        case .pushUp: "Flexão"
        case .sitUp: "Abdominal"
        case .squat: "Agachamento"
        case .running: "Corrida"
        }
    }

    private var progressDescription: String {
        switch exerciseType.measurementUnit {
        case .repetitions:
            "\(ExerciseAmountFormatter.repetitions(completedAmount)) de \(ExerciseAmountFormatter.repetitions(targetAmount))"
        case .meters:
            ExerciseAmountFormatter.distanceProgress(
                completedMeters: completedAmount,
                targetMeters: targetAmount
            )
        }
    }
}

#Preview {
    ScrollView {
        ExerciseRowButton(
            exerciseType: .pushUp,
            completedAmount: 10,
            targetAmount: 10,
            isCompleted: true,
            action: {}
        )

        ExerciseRowButton(
            exerciseType: .running,
            completedAmount: 0,
            targetAmount: 1_500,
            isCompleted: false,
            action: {}
        )

        ExerciseRowButton(
            exerciseType: .sitUp,
            completedAmount: 0,
            targetAmount: 10,
            isCompleted: false,
            action: {}
        )

        ExerciseRowButton(
            exerciseType: .squat,
            completedAmount: 0,
            targetAmount: 10,
            isCompleted: false,
            action: {}
        )
    }
    .padding()
    .background(Color.backgroundDefault)
}
