import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("일반")) {
                    Picker(selection: $themeManager.selectedTheme, label: Label("밝기 설정", systemImage: "sun.max")) {
                        ForEach(AppTheme.allCases) { theme in
                            Text(theme.rawValue == "System" ? "시스템 설정" : (theme.rawValue == "Light" ? "라이트 모드" : "다크 모드")).tag(theme)
                        }
                    }
                }
                
                Section(header: Text("정보"), footer: HStack {
                    Spacer()
                    Text("버전 1.0.0")
                        .font(.footnote)
                        .foregroundColor(.gray)
                    Spacer()
                }) {
                    NavigationLink(destination: Text("이용 약관")) {
                        Label("이용 약관", systemImage: "doc.text")
                    }
                }
            }
            .navigationTitle("설정")
            .listStyle(InsetGroupedListStyle())
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(ThemeManager())
}
