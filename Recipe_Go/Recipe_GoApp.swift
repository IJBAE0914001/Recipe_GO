//
//  Recipe_GoApp.swift
//  Recipe_Go
//
//  Created by B B on 11/25/25.
//

import SwiftUI

@main
struct Recipe_GoApp: App {
    // 코어 데이터 컨트롤러 (Core Data Controller)
    let persistenceController = PersistenceController.shared
    
    // 전역 상태 관리자 (Global State Managers)
    @StateObject private var themeManager = ThemeManager()
    @StateObject private var languageManager = LanguageManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                // 환경 객체 주입 (Inject Environment Objects)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(themeManager)
                .environmentObject(languageManager)
                // 테마 적용 (Apply Theme)
                .preferredColorScheme(themeManager.colorScheme)
        }
    }
}
