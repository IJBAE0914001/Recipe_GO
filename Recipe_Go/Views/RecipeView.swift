import SwiftUI

struct RecipeView: View {
    // 레시피 데이터 모델 (Recipe Data Model)
    let recipe: Recipe
    // 즐겨찾기 뷰 모델 (Favorites View Model)
    @EnvironmentObject var favoritesViewModel: FavoritesViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // 대표 이미지 (Hero Image)
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
                }
                
                // 컨텐츠 컨테이너 (Content Container)
                VStack(alignment: .leading, spacing: 24) {
                    // 헤더 (Header): 제목 및 카테고리
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text(recipe.title)
                                .font(.title)
                                .bold()
                                .foregroundColor(.primary)
                            
                            Spacer()
                        }
                        
                        // 카테고리 및 칼로리 정보
                        VStack(alignment: .leading, spacing: 4) {
                            // 카테고리 (Category)
                            if let category = recipe.category {
                                Label(category, systemImage: "tag.fill")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            
                            // 칼로리 (Calories)
                            if let calories = recipe.calories {
                                Label("\(calories) kcal", systemImage: "flame.fill")
                                    .font(.subheadline)
                                    .foregroundColor(.orange)
                            }
                        }
                        
                        Divider()
                    }
                    
                    // 재료 목록 (Ingredients)
                    VStack(alignment: .leading, spacing: 16) {
                        Text("재료")
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
                    
                    // 조리법 (Instructions)
                    VStack(alignment: .leading, spacing: 16) {
                        Text("조리법")
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
                .offset(y: -30) // 이미지를 살짝 덮는 효과 (Overlap effect)
            }
        }
        .edgesIgnoringSafeArea(.top)
        // 툴바 설정 (Toolbar Configuration)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                // 즐겨찾기 하트 버튼 (Heart Icon Button)
                Button(action: {
                    favoritesViewModel.toggleFavorite(recipe: recipe)
                }) {
                    Image(systemName: favoritesViewModel.isFavorite(recipe: recipe) ? "heart.fill" : "heart")
                        .foregroundColor(favoritesViewModel.isFavorite(recipe: recipe) ? .red : .primary)
                }
            }
        }
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
