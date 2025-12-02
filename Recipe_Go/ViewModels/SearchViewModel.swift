import SwiftUI
import Combine

@MainActor
class SearchViewModel: ObservableObject {
    @Published var recipes: [Recipe] = []
    @Published var searchText = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let service = RecipeService.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        $searchText
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] text in
                if !text.isEmpty {
                    Task {
                        await self?.searchRecipes(query: text)
                    }
                } else {
                    self?.recipes = []
                }
            }
            .store(in: &cancellables)
    }
    
    func searchRecipes(query: String) async {
        guard !query.isEmpty else { return }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let fetchedRecipes = try await service.fetchRecipes(query: query)
            recipes = fetchedRecipes
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}
