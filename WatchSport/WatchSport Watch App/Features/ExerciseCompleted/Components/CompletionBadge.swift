//
//  CompletionBadge.swift
//  WatchSport
//

import SwiftUI

struct CompletionBadge: View {
    var body: some View {
        Image(systemName: "checkmark")
            .font(.system(size: 28, weight: .bold))
            .foregroundStyle(Color.backgroundDefault)
            .frame(width: 56, height: 56)
            .background(
                LinearGradient(
                    colors: [.brandPurple, .brandBlue],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .clipShape(Circle())
            .accessibilityHidden(true)
    }
}

#Preview {
    CompletionBadge()
        .padding()
        .background(Color.backgroundDefault)
}
