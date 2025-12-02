import Foundation

class RecipeService {
    static let shared = RecipeService()
    
    private let baseURL = "https://www.themealdb.com/api/json/v1/1/"
    
    func fetchRecipes(query: String) async throws -> [Recipe] {
        guard let url = URL(string: "\(baseURL)search.php?s=\(query)") else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(RecipeResponse.self, from: data)
        return response.meals ?? []
    }
    
    func fetchRecipeDetail(id: String) async throws -> Recipe? {
        guard let url = URL(string: "\(baseURL)lookup.php?i=\(id)") else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(RecipeResponse.self, from: data)
        return response.meals?.first
    }
}
