import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var viewModel: FavoritesViewModel
    
    var body: some View {
        NavigationView {
            ScrollView {
                if viewModel.savedRecipes.isEmpty {
                    // 즐겨찾기 없음 상태 (Empty State)
                    VStack(spacing: 20) {
                        Image(systemName: "heart.slash")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        Text("아직 즐겨찾기가 없습니다")
                            .font(.title2)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, minHeight: 400)
                } else {
                    // 저장된 레시피 목록 (Saved Recipes List)
                    LazyVStack(spacing: 16) {
                        ForEach(viewModel.savedRecipes) { recipe in
                            NavigationLink(destination: RecipeView(recipe: recipe)) {
                                RecipeCard(recipe: recipe)
                            }
                            .buttonStyle(PlainButtonStyle()) // 기본 링크 스타일 제거 (Remove default link styling)
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("즐겨찾기")
            .background(Color(uiColor: .systemGroupedBackground))
        }
    }
}

#Preview {
    FavoritesView()
        .environmentObject(FavoritesViewModel())
}
