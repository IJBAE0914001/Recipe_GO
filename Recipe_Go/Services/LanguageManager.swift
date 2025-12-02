import SwiftUI

enum AppLanguage: String, CaseIterable, Identifiable {
    case english = "English"
    case korean = "Korean"
    
    var id: String { self.rawValue }
}

class LanguageManager: ObservableObject {
    @AppStorage("selectedLanguage") var selectedLanguage: AppLanguage = .english
    
    func localizedString(_ key: String) -> String {
        let translations: [String: [AppLanguage: String]] = [
            // Tab Bar
            "Home": [.english: "Home", .korean: "홈"],
            "Favorites": [.english: "Favorites", .korean: "즐겨찾기"],
            "Settings": [.english: "Settings", .korean: "설정"],
            
            // Home View
            "What would you like\nto cook today?": [.english: "What would you like\nto cook today?", .korean: "오늘 무엇을\n요리하시겠어요?"],
            "Search recipes...": [.english: "Search recipes...", .korean: "레시피 검색..."],
            "Loading...": [.english: "Loading...", .korean: "로딩 중..."],
            "Error": [.english: "Error", .korean: "오류"],
            
            // Settings View
            "General": [.english: "General", .korean: "일반"],
            "Display & Brightness": [.english: "Display & Brightness", .korean: "화면 및 밝기"],
            "Language": [.english: "Language", .korean: "언어"],
            "About": [.english: "About", .korean: "정보"],
            "Version": [.english: "Version", .korean: "버전"],
            "Terms of Service": [.english: "Terms of Service", .korean: "이용 약관"],
            
            // Search View
            "Search": [.english: "Search", .korean: "검색"],
            
            // Theme
            "System": [.english: "System", .korean: "시스템 설정"],
            "Light": [.english: "Light", .korean: "라이트 모드"],
            "Dark": [.english: "Dark", .korean: "다크 모드"]
        ]
        
        return translations[key]?[selectedLanguage] ?? key
    }
}
