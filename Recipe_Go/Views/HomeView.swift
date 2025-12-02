import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @EnvironmentObject var languageManager: LanguageManager
    
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 0) {
                // Sticky Header Area
                VStack(alignment: .leading, spacing: 20) {
                    // Header / Title Area
                    Text(languageManager.localizedString("What would you like\nto cook today?"))
                        .font(.largeTitle)
                        .bold()
                        .padding(.horizontal)
                        .padding(.top)
                    
                    // Search Bar Entry
                    NavigationLink(destination: SearchView()) {
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                            Text(languageManager.localizedString("Search recipes..."))
                                .foregroundColor(.gray)
                            Spacer()
                        }
                        .padding()
                        .background(Color(uiColor: .secondarySystemGroupedBackground)) // Adaptive background
                        .cornerRadius(10)
                        .padding(.horizontal)
                        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 2)
                    }
                }
                .padding(.bottom, 20)
                .background(Color(uiColor: .systemGroupedBackground)) // Match main background
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        if viewModel.isLoading {
                            ProgressView(languageManager.localizedString("Loading..."))
                                .frame(maxWidth: .infinity, minHeight: 200)
                        } else if let error = viewModel.errorMessage {
                            Text("\(languageManager.localizedString("Error")): \(error)")
                                .foregroundColor(.red)
                                .padding()
                        } else {
                            LazyVGrid(columns: columns, spacing: 20) {
                                ForEach(viewModel.recipes) { recipe in
                                    NavigationLink(destination: RecipeView(recipe: recipe)) {
                                        RecipeCard(recipe: recipe)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.top, 10) // Add some spacing between sticky header and content
                }
            }
            .navigationBarHidden(true)
            .background(Color(uiColor: .systemGroupedBackground))
            .task {
                if viewModel.recipes.isEmpty {
                    await viewModel.fetchRecommendations()
                }
            }
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(FavoritesViewModel())
        .environmentObject(LanguageManager())
}
