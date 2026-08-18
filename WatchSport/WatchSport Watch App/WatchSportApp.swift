//
//  WatchSportApp.swift
//  WatchSport Watch App
//
//  Created by Daniel Leal PImenta on 17/08/26.
//

import SwiftData
import SwiftUI

@main
struct WatchSport_Watch_AppApp: App {

    var body: some Scene {
        WindowGroup {
            AppRootView()
        }
        .modelContainer(for: [DailyChallenge.self, DailyExercise.self])
    }
}

#Preview {
    AppRootView()
        .modelContainer(for: [DailyChallenge.self, DailyExercise.self], inMemory: true)
}
