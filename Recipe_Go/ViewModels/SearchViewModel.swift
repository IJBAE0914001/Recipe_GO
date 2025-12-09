import SwiftUI
import Combine

@MainActor
class SearchViewModel: ObservableObject {
    // 게시된 속성 (Published Properties)
    @Published var recipes: [Recipe] = []       // 검색된 레시피 목록 (Searched Recipes)
    @Published var searchText = ""              // 검색어 (Search Text)
    @Published var isLoading = false            // 로딩 상태 (Loading State)
    @Published var errorMessage: String?        // 에러 메시지 (Error Message)
    
    // 서비스 및 구독 취소 저장소 (Service and Cancellables)
    private let service = RecipeService.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        // 검색어 변경 감지 (Observe Search Text Changes)
        $searchText
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main) // 0.5초 디바운스 (Debounce)
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
    
    // 레시피 검색 (Search Recipes)
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
