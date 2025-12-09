import SwiftUI

enum AppTheme: String, CaseIterable, Identifiable {
    case system = "System"
    case light = "Light"
    case dark = "Dark"
    
    var id: String { self.rawValue }
}

// 테마 설정 관리자 (Theme Manager)
class ThemeManager: ObservableObject {
    // 선택된 테마 (Selected Theme)
    // UserDefaults에 저장되어 앱 재실행 시에도 유지됩니다.
    @AppStorage("selectedTheme") var selectedTheme: AppTheme = .system
    
    // 현재 색상 스킴 반환 (Return Current Color Scheme)
    var colorScheme: ColorScheme? {
        switch selectedTheme {
        case .system:
            return nil
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }
}
