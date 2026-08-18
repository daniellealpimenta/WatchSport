//
//  ExerciseCountdownView.swift
//  WatchSport
//
//  Created by Lizandra Malta on 18/08/26.
//

import SwiftUI

struct ExerciseCountdownView: View {
    let value: Int

    static var transition: AnyTransition {
        .modifier(
            active: CountdownTransitionModifier(
                scale: 0.62,
                opacity: 0,
                blurRadius: 12
            ),
            identity: CountdownTransitionModifier(
                scale: 1,
                opacity: 1,
                blurRadius: 0
            )
        )
    }

    private var number: some View {
        Text("\(value)")
            .font(.system(size: 82, weight: .bold, design: .rounded))
            .monospacedDigit()
            .foregroundStyle(
                LinearGradient(
                    colors: [.brandPurple, .brandBlue],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
    }

    var body: some View {
        ZStack {
            number
                .blur(radius: 22)
                .opacity(0.4)

            number
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .accessibilityLabel("Começando em \(value)")
    }
}

private struct CountdownTransitionModifier: ViewModifier {
    let scale: CGFloat
    let opacity: Double
    let blurRadius: CGFloat

    func body(content: Content) -> some View {
        content
            .scaleEffect(scale)
            .opacity(opacity)
            .blur(radius: blurRadius)
    }
}
