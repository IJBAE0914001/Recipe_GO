import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var viewModel: FavoritesViewModel
    @EnvironmentObject var languageManager: LanguageManager
    
    var body: some View {
        NavigationView {
            ScrollView {
                if viewModel.savedRecipes.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "heart.slash")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        Text("No favorites yet")
                            .font(.title2)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, minHeight: 400)
                } else {
                    LazyVStack(spacing: 16) {
                        ForEach(viewModel.savedRecipes) { recipe in
                            NavigationLink(destination: RecipeView(recipe: recipe)) {
                                RecipeCard(recipe: recipe)
                            }
                            .buttonStyle(PlainButtonStyle()) // Remove default link styling
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle(languageManager.localizedString("Favorites"))
            .background(Color(uiColor: .systemGroupedBackground))
        }
    }
}

#Preview {
    FavoritesView()
        .environmentObject(FavoritesViewModel())
        .environmentObject(LanguageManager())
}
