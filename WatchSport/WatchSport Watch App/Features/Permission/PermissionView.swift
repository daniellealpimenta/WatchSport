//
//  PermissionView.swift
//  WatchSport
//

import SwiftUI

struct PermissionView: View {
    let viewModel: PermissionViewModel

    let onRetry: () -> Void
    let onDismiss: () -> Void

    var body: some View {
        ZStack {
            Color.backgroundDefault
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 8) {
                    PermissionBadge(systemImageName: viewModel.systemImageName)

                    VStack(spacing: 6) {
                        Text(viewModel.title)
                            .font(.system(size: 22, weight: .bold))
                            .foregroundStyle(Color.textPrimary)
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                            .minimumScaleFactor(0.8)

                        Text(viewModel.message)
                            .font(.system(size: 13, weight: .regular))
                            .foregroundStyle(Color.textSecondary)
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    VStack(spacing: 8) {
                        AppButton(
                            title: viewModel.retryTitle,
                            variant: .light,
                            action: onRetry
                        )

                        AppButton(
                            title: viewModel.dismissTitle,
                            variant: .dark,
                            action: onDismiss
                        )
                    }
                }
                .padding(.horizontal, 8)
                .padding(.bottom, 8)
            }
        }
        .navigationTitle(viewModel.navigationTitle)
    }
}

#Preview {
    NavigationStack {
        PermissionViewBuilder.build(kind: .health)
    }
}
