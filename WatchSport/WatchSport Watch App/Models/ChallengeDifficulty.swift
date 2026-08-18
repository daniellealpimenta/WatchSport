//
//  ChallengeDifficulty.swift
//  WatchSport
//

import Foundation

enum ChallengeDifficulty: String, Codable, CaseIterable {
    case easy
    case medium
    case hard
}

extension ChallengeDifficulty {
    var displayName: String {
        switch self {
        case .easy:
            "Fácil"
        case .medium:
            "Médio"
        case .hard:
            "Difícil"
        }
    }
}
