import SwiftUI
import Combine

@MainActor
class HomeViewModel: ObservableObject {
    @Published var recipes: [Recipe] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let service = RecipeService.shared
    
    func fetchRecommendations() async {
        isLoading = true
        errorMessage = nil
        
        do {
            // Fetch first 10 recipes for recommendations
            let fetchedRecipes = try await service.fetchRecipes(start: 1, end: 10)
            recipes = fetchedRecipes
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}
