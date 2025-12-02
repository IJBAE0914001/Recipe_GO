import Foundation

struct Ingredient: Codable, Hashable {
    let name: String
    let measure: String
}

extension Ingredient {
    static let preview = [
        Ingredient(name: "Pasta", measure: "500g"),
        Ingredient(name: "Bacon", measure: "200g"),
        Ingredient(name: "Eggs", measure: "4"),
        Ingredient(name: "Cheese", measure: "100g")
    ]
}
