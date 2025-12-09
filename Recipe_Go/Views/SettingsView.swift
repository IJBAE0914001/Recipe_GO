import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var languageManager: LanguageManager
    
    var body: some View {
        NavigationView {
            List {
                // 일반 설정 (General Settings)
                Section(header: Text(languageManager.localizedString("General"))) {
                    // 테마 설정 (Display & Brightness)
                    Picker(selection: $themeManager.selectedTheme, label: Label(languageManager.localizedString("Display & Brightness"), systemImage: "sun.max")) {
                        ForEach(AppTheme.allCases) { theme in
                            Text(languageManager.localizedString(theme.rawValue)).tag(theme)
                        }
                    }
                }
                
                // 앱 정보 (About)
                Section(header: Text(languageManager.localizedString("About")), footer: HStack {
                    Spacer()
                    // 앱 버전 표시 (App Version)
                    Text("\(languageManager.localizedString("Version")) 1.0.0")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.top, 20)
                    Spacer()
                }) {
                   // 이용약관 삭제됨 (Terms of Service removed)
                }
            }
            .navigationTitle(languageManager.localizedString("Settings"))
            .listStyle(InsetGroupedListStyle())
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(ThemeManager())
        .environmentObject(LanguageManager())
}
