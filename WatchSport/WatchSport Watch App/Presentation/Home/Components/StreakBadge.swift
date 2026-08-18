//
//  StreakBadge.swift
//  WatchSport
//

import SwiftUI

struct StreakBadge: View {
    let dayCount: Int

    private var displayedDayCount: Int {
        max(dayCount, 0)
    }

    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: "flame.fill")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(Color.warning)

            Text("\(displayedDayCount)")
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .foregroundStyle(Color.textPrimary)
                .monospacedDigit()
        }
        .padding(.horizontal, 12)
        .frame(minWidth: 54, minHeight: 36)
        .background(Color.surface)
        .clipShape(Capsule())
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Sequência diária")
        .accessibilityValue(accessibilityValue)
    }

    private var accessibilityValue: String {
        displayedDayCount == 1
            ? "1 dia consecutivo"
            : "\(displayedDayCount) dias consecutivos"
    }
}

#Preview {
    HStack {
        StreakBadge(dayCount: 1)
        StreakBadge(dayCount: 7)
    }
    .padding()
    .background(Color.backgroundDefault)
}
