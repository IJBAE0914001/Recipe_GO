import SwiftUI

struct RecipeCard: View {
    let recipe: Recipe
    @EnvironmentObject var favoritesViewModel: FavoritesViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Image Section
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
            
            // Content Section
            VStack(alignment: .leading, spacing: 8) {
                Text(recipe.title)
                    .font(.headline)
                    .lineLimit(2)
                    .foregroundColor(.primary)
                
                if let category = recipe.category {
                    Text(category)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(4)
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
