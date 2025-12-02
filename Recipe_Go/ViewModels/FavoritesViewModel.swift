import SwiftUI
import CoreData

@MainActor
class FavoritesViewModel: ObservableObject {
    @Published var savedRecipes: [Recipe] = []
    @Published var favoriteIDs: Set<String> = []
    
    private let viewContext = PersistenceController.shared.container.viewContext
    
    init() {
        fetchFavorites()
    }
    
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
    
    func toggleFavorite(recipe: Recipe) {
        let request = NSFetchRequest<NSManagedObject>(entityName: "RecipeEntity")
        request.predicate = NSPredicate(format: "id == %@", recipe.id)
        
        do {
            let results = try viewContext.fetch(request)
            if let existing = results.first {
                // Remove
                viewContext.delete(existing)
            } else {
                // Add
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
            fetchFavorites() // Refresh list and IDs
        } catch {
            print("Error toggling favorite: \(error)")
        }
    }
    
    func isFavorite(recipe: Recipe) -> Bool {
        return favoriteIDs.contains(recipe.id)
    }
}
