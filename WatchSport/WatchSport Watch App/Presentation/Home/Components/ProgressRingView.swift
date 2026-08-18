//
//  ProgressRingView.swift
//  WatchSport
//

import SwiftUI

struct ProgressRingView: View {
    let completedCount: Int
    let totalCount: Int

    private var progress: Double {
        guard totalCount > 0 else { return 0 }
        return min(max(Double(completedCount) / Double(totalCount), 0), 1)
    }

    private var percentage: Int {
        Int((progress * 100).rounded())
    }

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.surface, lineWidth: 12)

            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    AngularGradient(
                        colors: [.brandBlue, .brandPurple, .brandBlue],
                        center: .center,
                        startAngle: .degrees(0),
                        endAngle: .degrees(360)
                    ),
                    style: StrokeStyle(lineWidth: 12, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))

            VStack(spacing: 2) {
                Text("\(percentage)%")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.textPrimary)

                Text("CONCLUÍDO")
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundStyle(Color.textSecondary)
            }
        }
        .frame(width: 126, height: 126)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Progresso do desafio")
        .accessibilityValue("\(percentage) por cento concluído")
    }
}

#Preview {
    ProgressRingView(completedCount: 3, totalCount: 4)
        .padding()
        .background(Color.backgroundDefault)
}
