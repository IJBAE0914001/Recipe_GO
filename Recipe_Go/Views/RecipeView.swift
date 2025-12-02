import SwiftUI

struct RecipeView: View {
    let recipe: Recipe
    @EnvironmentObject var favoritesViewModel: FavoritesViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // Hero Image
                ZStack(alignment: .topTrailing) {
                    AsyncImage(url: URL(string: recipe.thumbnail ?? "")) { image in
                        image.resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .overlay(ProgressView())
                    }
                    .frame(height: 300)
                    .clipped()
                    .overlay(
                        LinearGradient(gradient: Gradient(colors: [.clear, .black.opacity(0.5)]), startPoint: .center, endPoint: .bottom)
                    )
                    
                    // Heart Icon on Image
                    Button(action: {
                        favoritesViewModel.toggleFavorite(recipe: recipe)
                    }) {
                        Image(systemName: favoritesViewModel.isFavorite(recipe: recipe) ? "heart.fill" : "heart")
                            .font(.title)
                            .foregroundColor(favoritesViewModel.isFavorite(recipe: recipe) ? .red : .white)
                            .padding()
                            .background(Color.black.opacity(0.3))
                            .clipShape(Circle())
                    }
                    .padding()
                }
                
                // Content Container
                VStack(alignment: .leading, spacing: 24) {
                    // Header
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text(recipe.title)
                                .font(.title)
                                .bold()
                                .foregroundColor(.primary)
                            
                            Spacer()
                        }
                        
                        if let category = recipe.category {
                            Text(category)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(20)
                        }
                    }
                    
                    // Ingredients
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Ingredients")
                            .font(.title2)
                            .bold()
                        
                        if let ingredients = recipe.ingredients {
                            VStack(spacing: 12) {
                                ForEach(ingredients, id: \.self) { ingredient in
                                    HStack {
                                        Text(ingredient.name)
                                            .font(.body)
                                        Spacer()
                                        Text(ingredient.measure)
                                            .font(.body)
                                            .foregroundColor(.secondary)
                                    }
                                    .padding()
                                    .background(Color.gray.opacity(0.05))
                                    .cornerRadius(10)
                                }
                            }
                        }
                    }
                    
                    // Instructions
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Recipe")
                            .font(.title2)
                            .bold()
                        
                        Text(recipe.instructions ?? "No instructions available.")
                            .font(.body)
                            .lineSpacing(6)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(24)
                .background(Color(uiColor: .systemBackground))
                .cornerRadius(30, corners: [.topLeft, .topRight])
                .offset(y: -30) // Overlap effect
            }
        }
        .edgesIgnoringSafeArea(.top)
    }
}

// Helper for rounded corners
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

#Preview {
    RecipeView(recipe: .preview)
        .environmentObject(FavoritesViewModel())
}
