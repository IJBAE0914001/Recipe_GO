import SwiftUI

struct RecipeCard: View {
    let recipe: Recipe
    @EnvironmentObject var favoritesViewModel: FavoritesViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // 이미지 영역 (Image Section)
            ZStack(alignment: .topTrailing) {
                AsyncImage(url: URL(string: recipe.thumbnail ?? "")) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .overlay(
                            Image(systemName: "photo")
                                .foregroundColor(.gray)
                        )
                }
                .frame(height: 150)
                .clipped()
                
                // 카드 내 하트 버튼 (Heart Button inside Card)
                Button(action: {
                    favoritesViewModel.toggleFavorite(recipe: recipe)
                }) {
                    Image(systemName: favoritesViewModel.isFavorite(recipe: recipe) ? "heart.fill" : "heart")
                        .foregroundColor(favoritesViewModel.isFavorite(recipe: recipe) ? .red : .white)
                        .padding(8)
                        .background(Color.black.opacity(0.3))
                        .clipShape(Circle())
                }
                .padding(8)
            }
            
            // 컨텐츠 영역 (Content Section)
            VStack(alignment: .leading, spacing: 8) {
                Text(recipe.title)
                    .font(.headline)
                    .lineLimit(2)
                    .foregroundColor(.primary)
                // 카테고리 및 칼로리 (Category and Calories)
                HStack {
                    if let category = recipe.category {
                        Text(category)
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.8))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(4)
                    }
                    
                    Spacer()
                    
                    if let calories = recipe.calories {
                        HStack(spacing: 4) {
                            Image(systemName: "flame.fill")
                                .font(.caption2)
                            Text("\(calories) kcal")
                                .font(.caption)
                        }
                        .foregroundColor(.orange)
                    }
                }
            }
            .padding(12)
        }
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    RecipeCard(recipe: .preview)
        .padding()
        .background(Color.gray.opacity(0.1))
        .environmentObject(FavoritesViewModel())
}
