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
            NavigationStack {
                HomeView()
            }
        }
        .modelContainer(for: [DailyChallenge.self, DailyExercise.self])
    }
}

#Preview {
    HomeView()
}
