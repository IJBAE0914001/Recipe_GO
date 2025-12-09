import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()
    @EnvironmentObject var languageManager: LanguageManager
    
    var body: some View {
        VStack(spacing: 0) {
            // 검색바 영역 (Search Bar Area)
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.black)
                TextField(languageManager.localizedString("Search recipes..."), text: $viewModel.searchText)
                    .foregroundColor(.black)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .padding()
            .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 2)
            
            // 검색 결과 목록 (Search Results List)
            ScrollView {
                if viewModel.isLoading {
                    ProgressView()
                        .padding(.top, 50)
                } else if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .padding()
                } else {
                    LazyVStack(spacing: 16) {
                        ForEach(viewModel.recipes) { recipe in
                            NavigationLink(destination: RecipeView(recipe: recipe)) {
                                RecipeCard(recipe: recipe)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationTitle(languageManager.localizedString("Search"))
        .background(Color(uiColor: .systemGroupedBackground))
    }
}

#Preview {
    SearchView()
        .environmentObject(FavoritesViewModel())
        .environmentObject(LanguageManager())
}
