//
//  RunMetricTile.swift
//  WatchSport
//

import SwiftUI

struct RunMetricTile<Value: View>: View {
    let title: String

    @ViewBuilder let value: Value

    var body: some View {
        VStack(spacing: 2) {
            Text(title)
                .font(.system(size: 11, weight: .regular))
                .foregroundStyle(Color.textSecondary)

            value
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
    HStack(spacing: 8) {
        RunMetricTile(title: "Tempo") { Text("08:32") }
        RunMetricTile(title: "Restante") { Text("0,68 km") }
    }
    .padding()
    .background(Color.backgroundDefault)
}
