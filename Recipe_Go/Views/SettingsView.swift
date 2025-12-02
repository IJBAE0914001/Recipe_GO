import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var languageManager: LanguageManager
    
    var body: some View {
        NavigationView {
            List {
                // General Settings
                Section(header: Text(languageManager.localizedString("General"))) {
                    Picker(selection: $themeManager.selectedTheme, label: Label(languageManager.localizedString("Display & Brightness"), systemImage: "sun.max")) {
                        ForEach(AppTheme.allCases) { theme in
                            Text(languageManager.localizedString(theme.rawValue)).tag(theme)
                        }
                    }
                    
                    Picker(selection: $languageManager.selectedLanguage, label: Label(languageManager.localizedString("Language"), systemImage: "globe")) {
                        ForEach(AppLanguage.allCases) { language in
                            Text(language.rawValue).tag(language)
                        }
                    }
                }
                
                // About
                Section(header: Text(languageManager.localizedString("About")), footer: HStack {
                    Spacer()
                    Text("\(languageManager.localizedString("Version")) 1.0.0")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.top, 20)
                    Spacer()
                }) {
                    NavigationLink(destination: Text("Terms of Service")) {
                        Label(languageManager.localizedString("Terms of Service"), systemImage: "doc.text")
                    }
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
