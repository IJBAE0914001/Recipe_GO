import SwiftUI

enum AppLanguage: String, CaseIterable, Identifiable {
    case english = "English"
    case korean = "Korean"
    
    var id: String { self.rawValue }
}

// 언어 설정 관리자 (Language Manager)
class LanguageManager: ObservableObject {
    // 선택된 언어 (Selected Language)
    // UserDefaults에 저장되어 앱 재실행 시에도 유지됩니다.
    @AppStorage("selectedLanguage") var selectedLanguage: AppLanguage = .english
    
    // 다국어 문자열 반환 (Return Localized String)
    func localizedString(_ key: String) -> String {
        let translations: [String: [AppLanguage: String]] = [
            // 탭 바 (Tab Bar)
            "Home": [.english: "Home", .korean: "홈"],
            "Favorites": [.english: "Favorites", .korean: "즐겨찾기"],
            "Settings": [.english: "Settings", .korean: "설정"],
            
            // 홈 화면 (Home View)
            "What would you like\nto cook today?": [.english: "What would you like\nto cook today?", .korean: "오늘 무엇을\n요리하시겠어요?"],
            "Search recipes...": [.english: "Search recipes...", .korean: "레시피 검색..."],
            "Loading...": [.english: "Loading...", .korean: "로딩 중..."],
            "Error": [.english: "Error", .korean: "오류"],
            
            // 설정 화면 (Settings View)
            "General": [.english: "General", .korean: "일반"],
            "Display & Brightness": [.english: "Display & Brightness", .korean: "화면 및 밝기"],
            "Language": [.english: "Language", .korean: "언어"],
            "About": [.english: "About", .korean: "정보"],
            "Version": [.english: "Version", .korean: "버전"],
            "Terms of Service": [.english: "Terms of Service", .korean: "이용 약관"],
            
            // 검색 화면 (Search View)
            "Search": [.english: "Search", .korean: "검색"],
            
            // 테마 (Theme)
            "System": [.english: "System", .korean: "시스템 설정"],
            "Light": [.english: "Light", .korean: "라이트 모드"],
            "Dark": [.english: "Dark", .korean: "다크 모드"]
        ]
        
        return translations[key]?[selectedLanguage] ?? key
    }
}
