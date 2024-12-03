//
//  TawuniyaTaskApp.swift
//  TawuniyaTask
//
//  Created by moamen ali gomaa on 03/12/2024.
//

import SwiftUI

@main
struct TawuniyaTaskApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
