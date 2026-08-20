//
//  PermissionBadge.swift
//  WatchSport
//

import SwiftUI

struct PermissionBadge: View {
    let systemImageName: String

    var body: some View {
        Image(systemName: systemImageName)
            .font(.system(size: 28, weight: .semibold))
            .foregroundStyle(Color.warning)
            .frame(width: 56, height: 56)
            .background(Color.warning.opacity(0.12))
            .clipShape(Circle())
            .accessibilityHidden(true)
    }
}

#Preview {
    PermissionBadge(systemImageName: "exclamationmark.shield.fill")
        .padding()
        .background(Color.backgroundDefault)
}
