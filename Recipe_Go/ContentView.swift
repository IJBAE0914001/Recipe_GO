import SwiftUI
import CoreData

struct ContentView: View {
    // 즐겨찾기 상태 관리 (Favorites State Management)
    @StateObject private var favoritesViewModel = FavoritesViewModel()
    // 언어 설정 관리 (Language Management)
    @EnvironmentObject var languageManager: LanguageManager
    
    var body: some View {
        // 메인 탭 뷰 (Main Tab View)
        TabView {
            // 홈 화면 (Home Tab)
            HomeView()
                .tabItem {
                    Label(languageManager.localizedString("Home"), systemImage: "house")
                }
            
            // 즐겨찾기 화면 (Favorites Tab)
            FavoritesView()
                .tabItem {
                    Label(languageManager.localizedString("Favorites"), systemImage: "heart.fill")
                }
            
            // 설정 화면 (Settings Tab)
            SettingsView()
                .tabItem {
                    Label(languageManager.localizedString("Settings"), systemImage: "gearshape.fill")
                }
        }
        // 즐겨찾기 모델 주입 (Inject Favorites Model)
        .environmentObject(favoritesViewModel)
    }
}

#Preview {
    ContentView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        .environmentObject(ThemeManager())
        .environmentObject(LanguageManager())
}
