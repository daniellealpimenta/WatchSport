//
//  PermissionViewBuilder.swift
//  WatchSport
//

enum PermissionViewBuilder {

    @MainActor
    static func build(
        kind: PermissionKind,
        onRetry: @escaping () -> Void = {},
        onDismiss: @escaping () -> Void = {}
    ) -> PermissionView {
        let viewModel = PermissionViewModel(kind: kind)

        return PermissionView(
            viewModel: viewModel,
            onRetry: onRetry,
            onDismiss: onDismiss
        )
    }
}
