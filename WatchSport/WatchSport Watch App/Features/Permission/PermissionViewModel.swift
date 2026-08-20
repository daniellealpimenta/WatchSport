//
//  PermissionViewModel.swift
//  WatchSport
//

/// Permissão do sistema que o app precisa e ainda não tem.
enum PermissionKind: Hashable {
    case health
}

struct PermissionViewModel {
    let kind: PermissionKind

    var systemImageName: String {
        switch kind {
        case .health:
            "exclamationmark.shield.fill"
        }
    }

    var title: String {
        switch kind {
        case .health:
            "Acesso necessário"
        }
    }

    var message: String {
        switch kind {
        case .health:
            """
            Precisamos do app Saúde para acompanhar seus exercícios. \
            Libere pelo iPhone, em Watch › Privacidade › Saúde.
            """
        }
    }

    var retryTitle: String {
        "Tentar novamente"
    }

    var dismissTitle: String {
        "Agora não"
    }

    var navigationTitle: String {
        "Permissão"
    }
}
