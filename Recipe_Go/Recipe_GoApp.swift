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
    @StateObject private var themeManager = ThemeManager()
    @StateObject private var languageManager = LanguageManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(themeManager)
                .environmentObject(languageManager)
                .preferredColorScheme(themeManager.colorScheme)
        }
    }
}
