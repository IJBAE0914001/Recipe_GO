import Foundation

struct RecipeResponse: Codable {
    let meals: [Recipe]?
}

struct Recipe: Codable, Identifiable {
    let id: String
    let title: String
    let category: String?
    let area: String?
    let instructions: String?
    let thumbnail: String?
    let tags: String?
    let youtube: String?
    let ingredients: [Ingredient]?
    
    var idMeal: String { id } // Alias for API mapping if needed, but we'll map manually or use CodingKeys
    
    enum CodingKeys: String, CodingKey {
        case id = "idMeal"
        case title = "strMeal"
        case category = "strCategory"
        case area = "strArea"
        case instructions = "strInstructions"
        case thumbnail = "strMealThumb"
        case tags = "strTags"
        case youtube = "strYoutube"
        // Ingredients are dynamic in MealDB (strIngredient1, strIngredient2...), handled in init(from decoder)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        category = try container.decodeIfPresent(String.self, forKey: .category)
        area = try container.decodeIfPresent(String.self, forKey: .area)
        instructions = try container.decodeIfPresent(String.self, forKey: .instructions)
        thumbnail = try container.decodeIfPresent(String.self, forKey: .thumbnail)
        tags = try container.decodeIfPresent(String.self, forKey: .tags)
        youtube = try container.decodeIfPresent(String.self, forKey: .youtube)
        
        // Dynamic ingredient parsing
        let dynamicContainer = try decoder.container(keyedBy: DynamicCodingKeys.self)
        var tempIngredients: [Ingredient] = []
        
        for i in 1...20 {
            let ingredientKey = DynamicCodingKeys(stringValue: "strIngredient\(i)")!
            let measureKey = DynamicCodingKeys(stringValue: "strMeasure\(i)")!
            
            if let ingredient = try dynamicContainer.decodeIfPresent(String.self, forKey: ingredientKey),
               !ingredient.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                let measure = try dynamicContainer.decodeIfPresent(String.self, forKey: measureKey) ?? ""
                tempIngredients.append(Ingredient(name: ingredient, measure: measure))
            }
        }
        ingredients = tempIngredients
    }
    
    // Helper for manual initialization (e.g. from CoreData)
    init(id: String, title: String, thumbnail: String?, instructions: String?, ingredients: [Ingredient]?) {
        self.id = id
        self.title = title
        self.thumbnail = thumbnail
        self.instructions = instructions
        self.ingredients = ingredients
        self.category = nil
        self.area = nil
        self.tags = nil
        self.youtube = nil
    }
}



struct DynamicCodingKeys: CodingKey {
    var stringValue: String
    init?(stringValue: String) {
        self.stringValue = stringValue
    }
    var intValue: Int?
    init?(intValue: Int) {
        return nil
    }
}
