//
//  HabitsTrackerApp.swift
//  HabitsTracker
//
//  Created by Héctor Beristain on 28/06/26.
//

import SwiftUI
import SwiftData

@main
struct HabitsTrackerApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            ItemList.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
