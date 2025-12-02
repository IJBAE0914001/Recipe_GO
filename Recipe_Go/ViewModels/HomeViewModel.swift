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
            // For "Today's Recommendation", we can fetch a random recipe or a specific category.
            // MealDB supports random via 'random.php', but let's search for a common term like 'Chicken' for now to show a list.
            // Or we can fetch a few random ones. Let's try searching 'Chicken' as a default for the home feed.
            let fetchedRecipes = try await service.fetchRecipes(query: "Chicken")
            recipes = fetchedRecipes
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}
