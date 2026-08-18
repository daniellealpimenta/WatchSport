//
//  AppRootView.swift
//  WatchSport
//

import SwiftData
import SwiftUI

struct AppRootView: View {
    @Environment(\.modelContext) private var modelContext
    @AppStorage(UserDefaultsKey.hasCompletedOnboarding) private var hasCompletedOnboarding = false

    var body: some View {
        NavigationStack {
            if hasCompletedOnboarding {
                HomeViewBuilder.build(context: modelContext)
            } else {
                OnboardingView()
            }
        }
    }
}

#Preview {
    AppRootView()
        .modelContainer(for: [DailyChallenge.self, DailyExercise.self], inMemory: true)
}
