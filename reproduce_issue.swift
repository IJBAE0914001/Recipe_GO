import Foundation

// MARK: - API Response Models

struct FoodSafetyResponse: Codable {
    let cookRcp01: CookRcp01?
    
    enum CodingKeys: String, CodingKey {
        case cookRcp01 = "COOKRCP01"
    }
}

struct CookRcp01: Codable {
    let row: [FoodSafetyRecipe]?
    
    enum CodingKeys: String, CodingKey {
        case row
    }
}

struct FoodSafetyRecipe: Codable {
    let rcpNm: String
    let attFileNoMain: String
    
    enum CodingKeys: String, CodingKey {
        case rcpNm = "RCP_NM"
        case attFileNoMain = "ATT_FILE_NO_MAIN"
    }
}

// MARK: - Service Logic

let apiKey = "27537ff66abe4700a627"
let serviceId = "COOKRCP01"
let baseURL = "https://openapi.foodsafetykorea.go.kr/api/"

func fetchRecipes() async {
    let urlString = "\(baseURL)\(apiKey)/\(serviceId)/json/1/5"
    
    guard let url = URL(string: urlString) else {
        print("Invalid URL")
        return
    }
    
    do {
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(FoodSafetyResponse.self, from: data)
        
        if let rows = response.cookRcp01?.row {
            for recipe in rows {
                print("Recipe: \(recipe.rcpNm)")
                print("Original Image URL: \(recipe.attFileNoMain)")
                let fixedUrl = recipe.attFileNoMain.replacingOccurrences(of: "http://", with: "https://")
                print("Fixed Image URL:    \(fixedUrl)")
                print("---")
            }
        } else {
            print("No recipes found or parsed incorrectly.")
        }
    } catch {
        print("Error fetching recipes: \(error)")
    }
}

// MARK: - Main Execution

let semaphore = DispatchSemaphore(value: 0)

Task {
    await fetchRecipes()
    semaphore.signal()
}

semaphore.wait()
