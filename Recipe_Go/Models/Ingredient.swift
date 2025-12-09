import Foundation

// 재료 모델 (Ingredient Model)
struct Ingredient: Codable, Hashable {
    let name: String    // 재료명 (Name)
    let measure: String // 계량 (Measurement)
}

extension Ingredient {
    static let preview = [
        Ingredient(name: "Pasta", measure: "500g"),
        Ingredient(name: "Bacon", measure: "200g"),
        Ingredient(name: "Eggs", measure: "4"),
        Ingredient(name: "Cheese", measure: "100g")
    ]
}
