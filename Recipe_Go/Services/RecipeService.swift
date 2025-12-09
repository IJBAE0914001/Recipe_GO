import Foundation

class RecipeService {
    static let shared = RecipeService()
    
    private let apiKey = "27537ff66abe4700a627"
    private let serviceId = "COOKRCP01"
    private let baseURL = "https://openapi.foodsafetykorea.go.kr/api/"
    
    func fetchRecipes(start: Int, end: Int) async throws -> [Recipe] {
        let urlString = "\(baseURL)\(apiKey)/\(serviceId)/json/\(start)/\(end)"
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(FoodSafetyResponse.self, from: data)
        
        guard let rows = response.cookRcp01?.row else {
            return []
        }
        
        return rows.map { Recipe(from: $0) }
    }
    
    func fetchRecipes(query: String) async throws -> [Recipe] {
        // Encode the query for URL
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            throw URLError(.badURL)
        }
        
        // Search API format: .../RCP_NM=Query
        let urlString = "\(baseURL)\(apiKey)/\(serviceId)/json/1/100/RCP_NM=\(encodedQuery)"
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(FoodSafetyResponse.self, from: data)
        
        guard let rows = response.cookRcp01?.row else {
            return []
        }
        
        return rows.map { Recipe(from: $0) }
    }
    
    // Helper to fetch details if needed, but the list API returns full details
    func fetchRecipeDetail(id: String) async throws -> Recipe? {
        // Since the API doesn't support direct ID lookup easily without scanning,
        // we might rely on passing the Recipe object around.
        // However, if we really need to fetch by ID, we might need to search or iterate.
        // For now, returning nil as we should have the data from the list.
        return nil
    }
}
