//
//  MissionSummaryRow.swift
//  WatchSport
//

import SwiftUI

struct MissionSummaryRow: View {
    let title: String
    let amountDescription: String

    var body: some View {
        HStack(spacing: 8) {
            Text(title)
                .font(.system(size: 14, weight: .regular))
                .foregroundStyle(Color.textSecondary)
                .lineLimit(1)
                .minimumScaleFactor(0.8)

            Spacer(minLength: 4)

            Text(amountDescription)
                .font(.system(size: 15, weight: .bold, design: .rounded))
                .foregroundStyle(Color.textPrimary)
                .monospacedDigit()
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
        .padding(.horizontal, 12)
        .frame(maxWidth: .infinity, minHeight: 44)
        .background(Color.surface)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(title)
        .accessibilityValue(amountDescription)
    }
}

#Preview {
    VStack(spacing: 6) {
        MissionSummaryRow(title: "Flexão", amountDescription: "10")
        MissionSummaryRow(title: "Corrida", amountDescription: "1,5 km")
    }
    .padding()
    .background(Color.backgroundDefault)
}
