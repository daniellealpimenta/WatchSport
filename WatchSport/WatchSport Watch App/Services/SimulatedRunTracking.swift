//
//  SimulatedRunTracking.swift
//  WatchSport
//

#if targetEnvironment(simulator)
import Foundation

/// O simulador não gera dados de distância do HealthKit, então a corrida avança
/// em um ritmo fixo apenas para permitir testar o fluxo.
final class SimulatedRunTracking: RunTracking {
    var onDistanceUpdate: ((Double) -> Void)?

    private let metersPerTick: Double = 25
    private var meters: Double = 0
    private var task: Task<Void, Never>?

    func start() async throws {
        task?.cancel()
        meters = 0

        task = Task { [weak self] in
            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(1))
                guard let self, !Task.isCancelled else { return }

                self.meters += self.metersPerTick
                self.onDistanceUpdate?(self.meters)
            }
        }
    }

    func stop() async {
        task?.cancel()
        task = nil
    }
}
#endif
