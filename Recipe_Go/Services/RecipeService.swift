import Foundation

class RecipeService {
    static let shared = RecipeService()
    
    // API 키 및 설정 (API Key and Configuration)
    private let apiKey = "27537ff66abe4700a627"
    private let serviceId = "COOKRCP01"
    private let baseURL = "https://openapi.foodsafetykorea.go.kr/api/"
    
    // 범위로 레시피 가져오기 (Fetch Recipes by Range)
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
    
    // 검색어로 레시피 가져오기 (Fetch Recipes by Query)
    func fetchRecipes(query: String) async throws -> [Recipe] {
        // URL 인코딩 (Encode the query for URL)
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            throw URLError(.badURL)
        }
        
        // 검색 API 형식 (Search API format): .../RCP_NM=Query
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
    
    // 상세 정보 가져오기 헬퍼 (Helper to fetch details)
    // 현재는 리스트 API에서 모든 정보를 주므로 구현하지 않음 (Currently not implemented as list API returns full details)
    func fetchRecipeDetail(id: String) async throws -> Recipe? {
        return nil
    }
}
