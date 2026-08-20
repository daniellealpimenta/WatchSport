//
//  MissionStreakPill.swift
//  WatchSport
//

import SwiftUI

struct MissionStreakPill: View {
    let description: String

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "flame.fill")
                .font(.system(size: 12, weight: .semibold))

            Text(description)
                .font(.system(size: 12, weight: .semibold))
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
        .foregroundStyle(Color.brandPurple)
        .padding(.horizontal, 10)
        .frame(minHeight: 28)
        .background(Color.brandPurple.opacity(0.15))
        .clipShape(Capsule())
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(description)
    }
}

#Preview {
    MissionStreakPill(description: "Sequência de 8 dias")
        .padding()
        .background(Color.backgroundDefault)
}
