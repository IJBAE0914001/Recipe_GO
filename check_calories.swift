import Foundation

struct FoodSafetyResponse: Codable {
    let cookRcp01: CookRcp01?
    enum CodingKeys: String, CodingKey { case cookRcp01 = "COOKRCP01" }
}

struct CookRcp01: Codable {
    let row: [RawRecipe]?
    enum CodingKeys: String, CodingKey { case row }
}

// Use a dictionary to capture all fields
struct RawRecipe: Codable {
    let rcpSeq: String
    let rcpNm: String
    let infoEng: String // Check if this maps correctly
    
    enum CodingKeys: String, CodingKey {
        case rcpSeq = "RCP_SEQ"
        case rcpNm = "RCP_NM"
        case infoEng = "INFO_ENG"
    }
}

let apiKey = "4883490974804365851f"
let serviceId = "COOKRCP01"
let urlString = "https://openapi.foodsafetykorea.go.kr/api/\(apiKey)/\(serviceId)/json/1/1"

guard let url = URL(string: urlString) else {
    print("Invalid URL")
    exit(1)
}

let task = URLSession.shared.dataTask(with: url) { data, response, error in
    if let error = error {
        print("Error: \(error)")
        exit(1)
    }
    
    guard let data = data else {
        print("No data")
        exit(1)
    }
    
    do {
        // First try to parse with our assumption
        let decoder = JSONDecoder()
        let response = try decoder.decode(FoodSafetyResponse.self, from: data)
        
        if let firstRecipe = response.cookRcp01?.row?.first {
            print("Recipe: \(firstRecipe.rcpNm)")
            print("Calories (INFO_ENG): \(firstRecipe.infoEng)")
        } else {
            print("No recipes found")
        }
        
    } catch {
        print("Decoding error: \(error)")
        // If decoding fails, print raw string to see correct field name
        if let jsonString = String(data: data, encoding: .utf8) {
             print("Raw JSON: \(jsonString)")
        }
    }
    exit(0)
}

task.resume()
dispatchMain()
