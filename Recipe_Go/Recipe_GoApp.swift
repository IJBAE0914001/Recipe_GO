//
//  Recipe_GoApp.swift
//  Recipe_Go
//
//  Created by B B on 11/25/25.
//

import SwiftUI

@main
struct Recipe_GoApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
