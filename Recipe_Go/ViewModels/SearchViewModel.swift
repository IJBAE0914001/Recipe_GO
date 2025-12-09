import SwiftUI
import Combine

@MainActor
class SearchViewModel: ObservableObject {
    // 게시된 속성 (Published Properties)
    @Published var recipes: [Recipe] = []       // 검색된 레시피 목록 (Searched Recipes)
    @Published var searchText = ""              // 검색어 (Search Text)
    @Published var isLoading = false            // 로딩 상태 (Loading State)
    @Published var errorMessage: String?        // 에러 메시지 (Error Message)
    @Published var recentSearches: [String] = [] // 최근 검색어 목록 (Recent Search History)
    
    // 서비스 및 구독 취소 저장소 (Service and Cancellables)
    private let service = RecipeService.shared
    private var cancellables = Set<AnyCancellable>()
    private let recentSearchesKey = "RecentSearches" // UserDefaults 키 (Key)
    
    init() {
        loadRecentSearches()
        
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
    
    // 최근 검색어 불러오기 (Load Recent Searches)
    private func loadRecentSearches() {
        if let saved = UserDefaults.standard.stringArray(forKey: recentSearchesKey) {
            recentSearches = saved
        }
    }
    
    // 최근 검색어 추가 (Add Recent Search)
    func addRecentSearch(_ query: String) {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        
        // 중복 제거 (Remove Duplicate)
        if let index = recentSearches.firstIndex(of: trimmed) {
            recentSearches.remove(at: index)
        }
        
        // 최상단에 추가 (Add to Top)
        recentSearches.insert(trimmed, at: 0)
        
        // 최대 10개 유지 (Limit to 10)
        if recentSearches.count > 10 {
            recentSearches.removeLast()
        }
        
        saveRecentSearches()
    }
    
    // 최근 검색어 삭제 (Remove Recent Search)
    func removeRecentSearch(at offsets: IndexSet) {
        recentSearches.remove(atOffsets: offsets)
        saveRecentSearches()
    }
    
    // 최근 검색어 전체 삭제 (Clear All Recent Searches)
    func clearRecentSearches() {
        recentSearches.removeAll()
        saveRecentSearches()
    }
    
    // 저장 (Save)
    private func saveRecentSearches() {
        UserDefaults.standard.set(recentSearches, forKey: recentSearchesKey)
    }
    
    // 레시피 검색 (Search Recipes)
    func searchRecipes(query: String) async {
        guard !query.isEmpty else { return }
        
        isLoading = true
        errorMessage = nil
        
        // 검색 시 최근 검색어에 추가 (Add to recent searches on search)
        // Note: debounce로 자동 검색되므로 여기서 저장하면 타이핑 중에도 저장될 수 있음.
        // UI에서 onSubmit 등을 통해 명시적으로 호출하는 것이 좋음.
        // addRecentSearch(query) <- 여기서는 호출하지 않음. View에서 처리.
        
        do {
            let fetchedRecipes = try await service.fetchRecipes(query: query)
            recipes = fetchedRecipes
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}
