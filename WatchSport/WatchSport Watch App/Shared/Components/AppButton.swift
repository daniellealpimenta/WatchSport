//
//  AppButton.swift
//  WatchSport
//

import SwiftUI

enum AppButtonVariant {
    case light
    case dark
    case gradient
}

struct AppButton: View {
    @Environment(\.isEnabled) private var isEnabled

    let title: String
    var variant: AppButtonVariant = .gradient
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 15, weight: .bold))
                .foregroundStyle(foregroundColor)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .minimumScaleFactor(0.8)
                .frame(maxWidth: .infinity, minHeight: 48)
                .padding(.horizontal, 12)
                .background(backgroundStyle)
                .clipShape(RoundedRectangle(cornerRadius: .infinity, style: .continuous))
        }
        .buttonStyle(.plain)
        .opacity(isEnabled ? 1 : 0.5)
    }

    private var foregroundColor: Color {
        switch variant {
        case .light,  .gradient:
            .backgroundDefault
        case .dark:
            .textPrimary
        }
    }

    private var backgroundStyle: AnyShapeStyle {
        switch variant {
        case .light:
            AnyShapeStyle(Color.textPrimary)
        case .dark:
            AnyShapeStyle(Color.surface)
        case .gradient:
            AnyShapeStyle(
                LinearGradient(
                    colors: [.brandPurple, .brandBlue],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
        }
    }
}

#Preview {
    VStack(spacing: 8) {
        AppButton(title: "Botão claro", variant: .light, action: {})
        AppButton(title: "Botão escuro", variant: .dark, action: {})
        AppButton(title: "Botão gradiente", variant: .gradient, action: {})
    }
    .padding()
    .background(Color.backgroundDefault)
}
