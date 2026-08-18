//
//  ErrorStateView.swift
//  WatchSport
//

import SwiftUI

struct ErrorStateView: View {
    let message: String

    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 30, weight: .semibold))
                .foregroundStyle(Color.warning)

            Text("Algo deu errado")
                .font(.system(size: 17, weight: .bold))
                .foregroundStyle(Color.textPrimary)
                .multilineTextAlignment(.center)

            Text(message)
                .font(.system(size: 13, weight: .regular))
                .foregroundStyle(Color.textSecondary)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(16)
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    ErrorStateView(message: "Não foi possível carregar o desafio diário.")
        .background(Color.backgroundDefault)
}
