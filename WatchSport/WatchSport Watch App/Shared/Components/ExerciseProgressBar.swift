//
//  ExerciseProgressBar.swift
//  WatchSport
//

import SwiftUI

struct ExerciseProgressBar: View {
    let progress: Double

    private var normalizedProgress: Double {
        min(max(progress, 0), 1)
    }

    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.surface)

                Capsule()
                    .fill(
                        LinearGradient(
                            colors: [.brandPurple, .brandBlue],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: proxy.size.width * normalizedProgress)
            }
        }
        .frame(height: 8)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Progresso do exercício")
        .accessibilityValue("\(Int((normalizedProgress * 100).rounded())) por cento")
    }
}

#Preview {
    ExerciseProgressBar(progress: 0.75)
        .padding()
        .background(Color.backgroundDefault)
}
