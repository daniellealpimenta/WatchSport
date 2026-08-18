//
//  DifficultyOptionButton.swift
//  WatchSport
//

import SwiftUI

struct DifficultyOptionButton: View {
    let difficulty: ChallengeDifficulty
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(difficulty.displayName)
                        .font(.system(size: 17, weight: .bold))
                        .foregroundStyle(Color.textPrimary)

                    Text(description)
                        .font(.system(size: 12, weight: .regular))
                        .foregroundStyle(Color.textSecondary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                }

                Spacer(minLength: 8)

                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(isSelected ? Color.brandPurple : Color.textSecondary)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 4)
            .frame(maxWidth: .infinity, minHeight: 54)
            .background(isSelected ? Color.brandPurple.opacity(0.16) : Color.surface)
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .stroke(isSelected ? Color.brandPurple : Color.clear, lineWidth: 1)
            }
        }
        .buttonStyle(.plain)
        .accessibilityLabel(difficulty.displayName)
        .accessibilityValue(isSelected ? "Selecionado" : "Não selecionado")
    }
}

extension DifficultyOptionButton {
    private var description: String {
        switch difficulty {
        case .easy:
            "Para começar no seu ritmo"
        case .medium:
            "Um desafio equilibrado"
        case .hard:
            "Para treinos mais intensos"
        }
    }
}

#Preview {
    VStack(spacing: 8) {
        DifficultyOptionButton(difficulty: .easy, isSelected: false, action: {})
        DifficultyOptionButton(difficulty: .medium, isSelected: true, action: {})
        DifficultyOptionButton(difficulty: .hard, isSelected: false, action: {})
    }
    .padding()
    .background(Color.backgroundDefault)
}
