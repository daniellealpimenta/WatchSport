//
//  RunTracking.swift
//  WatchSport
//

import Foundation

/// Fonte de distância percorrida durante uma corrida.
protocol RunTracking: AnyObject {
    /// Distância acumulada, em metros.
    var onDistanceUpdate: ((Double) -> Void)? { get set }

    func start() async throws
    func stop() async
}

enum RunTrackingError: LocalizedError {
    case healthDataUnavailable
    case authorizationDenied

    var errorDescription: String? {
        switch self {
        case .healthDataUnavailable:
            "Este dispositivo não tem dados de saúde disponíveis."
        case .authorizationDenied:
            "Precisamos da sua permissão no app Saúde para medir a corrida."
        }
    }
}
