import SwiftUI
import CoreData

struct ContentView: View {
    // 즐겨찾기 상태 관리 (Favorites State Management)
    // 즐겨찾기 상태 관리 (Favorites State Management)
    @StateObject private var favoritesViewModel = FavoritesViewModel()
    
    var body: some View {
        // 메인 탭 뷰 (Main Tab View)
        TabView {
            // 홈 화면 (Home Tab)
            HomeView()
                .tabItem {
                    Label("홈", systemImage: "house")
                }
            
            // 즐겨찾기 화면 (Favorites Tab)
            FavoritesView()
                .tabItem {
                    Label("즐겨찾기", systemImage: "heart.fill")
                }
            
            // 설정 화면 (Settings Tab)
            SettingsView()
                .tabItem {
                    Label("설정", systemImage: "gearshape.fill")
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
}
