import SwiftUI
import CoreData

@MainActor
class FavoritesViewModel: ObservableObject {
    // 게시된 속성 (Published Properties)
    @Published var savedRecipes: [Recipe] = []      // 저장된 레시피 목록 (Saved Recipes)
    @Published var favoriteIDs: Set<String> = []    // 즐겨찾기 ID 집합 (Favorite IDs Set)
    
    // Core Data Context
    private let viewContext = PersistenceController.shared.container.viewContext
    
    init() {
        fetchFavorites()
    }
    
    // 즐겨찾기 목록 가져오기 (Fetch Favorites)
    func fetchFavorites() {
        let request = NSFetchRequest<NSManagedObject>(entityName: "RecipeEntity")
        
        do {
            let items = try viewContext.fetch(request)
            savedRecipes = items.compactMap { item in
                guard let id = item.value(forKey: "id") as? String,
                      let title = item.value(forKey: "title") as? String else { return nil }
                
                let thumbnail = item.value(forKey: "thumbnail") as? String
                let instructions = item.value(forKey: "instructions") as? String
                let ingredientsData = item.value(forKey: "ingredientsData") as? Data
                
                var ingredients: [Ingredient]?
                if let data = ingredientsData {
                    ingredients = try? JSONDecoder().decode([Ingredient].self, from: data)
                }
                
                return Recipe(id: id, title: title, thumbnail: thumbnail, instructions: instructions, ingredients: ingredients)
            }
            favoriteIDs = Set(savedRecipes.map { $0.id })
        } catch {
            print("Error fetching favorites: \(error)")
        }
    }
    
    // 즐겨찾기 토글 (Toggle Favorite)
    func toggleFavorite(recipe: Recipe) {
        let request = NSFetchRequest<NSManagedObject>(entityName: "RecipeEntity")
        request.predicate = NSPredicate(format: "id == %@", recipe.id)
        
        do {
            let results = try viewContext.fetch(request)
            if let existing = results.first {
                // 삭제 (Remove)
                viewContext.delete(existing)
            } else {
                // 추가 (Add)
                guard let entity = NSEntityDescription.entity(forEntityName: "RecipeEntity", in: viewContext) else { return }
                let newItem = NSManagedObject(entity: entity, insertInto: viewContext)
                
                newItem.setValue(recipe.id, forKey: "id")
                newItem.setValue(recipe.title, forKey: "title")
                newItem.setValue(recipe.thumbnail, forKey: "thumbnail")
                newItem.setValue(recipe.instructions, forKey: "instructions")
                
                if let ingredients = recipe.ingredients,
                   let data = try? JSONEncoder().encode(ingredients) {
                    newItem.setValue(data, forKey: "ingredientsData")
                }
            }
            try viewContext.save()
            fetchFavorites() // 목록 및 ID 갱신 (Refresh list and IDs)
        } catch {
            print("Error toggling favorite: \(error)")
        }
    }
    
    // 즐겨찾기 여부 확인 (Check if Favorite)
    func isFavorite(recipe: Recipe) -> Bool {
        return favoriteIDs.contains(recipe.id)
    }
}
