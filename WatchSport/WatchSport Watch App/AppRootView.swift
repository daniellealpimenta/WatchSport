//
//  AppRootView.swift
//  WatchSport
//

import SwiftData
import SwiftUI

struct AppRootView: View {
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        NavigationStack {
            HomeViewBuilder.build(context: modelContext)
        }
    }
}

#Preview {
    AppRootView()
        .modelContainer(for: [DailyChallenge.self, DailyExercise.self], inMemory: true)
}
