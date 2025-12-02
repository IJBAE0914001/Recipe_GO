import SwiftUI
import CoreData

struct ContentView: View {
    @StateObject private var favoritesViewModel = FavoritesViewModel()
    @EnvironmentObject var languageManager: LanguageManager
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label(languageManager.localizedString("Home"), systemImage: "house")
                }
            
            FavoritesView()
                .tabItem {
                    Label(languageManager.localizedString("Favorites"), systemImage: "heart.fill")
                }
            
            SettingsView()
                .tabItem {
                    Label(languageManager.localizedString("Settings"), systemImage: "gearshape.fill")
                }
        }
        .environmentObject(favoritesViewModel)
    }
}

#Preview {
    ContentView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        .environmentObject(ThemeManager())
        .environmentObject(LanguageManager())
}
