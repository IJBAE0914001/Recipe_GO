import SwiftUI
import Combine

@MainActor
class HomeViewModel: ObservableObject {
    // 게시된 속성 (Published Properties)
    @Published var recipes: [Recipe] = []       // 추천 레시피 목록 (Recommended Recipes)
    @Published var isLoading = false            // 로딩 상태 (Loading State)
    @Published var errorMessage: String?        // 에러 메시지 (Error Message)
    
    private let service = RecipeService.shared
    
    // 추천 레시피 가져오기 (Fetch Recommendations)
    func fetchRecommendations() async {
        isLoading = true
        errorMessage = nil
        
        do {
            // 처음 10개 레시피를 추천으로 가져옴 (Fetch first 10 recipes for recommendations)
            let fetchedRecipes = try await service.fetchRecipes(start: 1, end: 10)
            recipes = fetchedRecipes
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}
