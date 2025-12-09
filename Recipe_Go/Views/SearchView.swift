import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            // 검색바 영역 (Search Bar Area)
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.black)
                TextField("레시피 검색...", text: $viewModel.searchText)
                    .foregroundColor(.black)
                    .onSubmit {
                        viewModel.addRecentSearch(viewModel.searchText)
                    }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .padding()
            .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 2)
            
            // 컨텐츠 영역 (Content Area)
            if viewModel.searchText.isEmpty && !viewModel.recentSearches.isEmpty {
                // 최근 검색어 목록 (Recent Search History)
                VStack(alignment: .leading) {
                    HStack {
                        Text("최근 검색어")
                            .font(.headline)
                            .foregroundColor(.gray)
                        Spacer()
                        Button(action: {
                            viewModel.clearRecentSearches()
                        }) {
                            Text("전체 삭제")
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    
                    List {
                        ForEach(viewModel.recentSearches, id: \.self) { term in
                            Button(action: {
                                viewModel.searchText = term
                                viewModel.addRecentSearch(term) // Re-add to move to top
                                Task {
                                    await viewModel.searchRecipes(query: term)
                                }
                            }) {
                                HStack {
                                    Text(term)
                                        .foregroundColor(.primary)
                                    Spacer()
                                    Image(systemName: "arrow.up.left")
                                        .foregroundColor(.gray)
                                        .font(.caption)
                                }
                            }
                        }
                        .onDelete(perform: viewModel.removeRecentSearch)
                    }
                    .listStyle(PlainListStyle())
                }
            } else {
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
        }
        .navigationTitle("검색")
        .background(Color(uiColor: .systemGroupedBackground))
    }
}

#Preview {
    SearchView()
        .environmentObject(FavoritesViewModel())
}
