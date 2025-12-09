import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    
    // 그리드 레이아웃 설정 (Grid Layout Configuration)
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 0) {
                // 고정 헤더 영역 (Sticky Header Area)
                VStack(alignment: .leading, spacing: 20) {
                    // 헤더 / 타이틀 영역 (Header / Title Area)
                    Text("오늘 무엇을\n요리하시겠어요?")
                        .font(.largeTitle)
                        .bold()
                        .padding(.horizontal)
                        .padding(.top)
                    
                    // 검색바 진입점 (Search Bar Entry)
                    NavigationLink(destination: SearchView()) {
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                            Text("레시피 검색...")
                                .foregroundColor(.gray)
                            Spacer()
                        }
                        .padding()
                        .background(Color(uiColor: .secondarySystemGroupedBackground)) // 반응형 배경 (Adaptive background)
                        .cornerRadius(10)
                        .padding(.horizontal)
                        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 2)
                    }
                }
                .padding(.bottom, 20)
                .background(Color(uiColor: .systemGroupedBackground)) // 메인 배경과 일치 (Match main background)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        if viewModel.isLoading {
                            ProgressView("로딩 중...")
                                .frame(maxWidth: .infinity, minHeight: 200)
                        } else if let error = viewModel.errorMessage {
                            Text("오류: \(error)")
                                .foregroundColor(.red)
                                .padding()
                        } else {
                            // 추천 레시피 그리드 (Recommended Recipes Grid)
                            LazyVGrid(columns: columns, spacing: 20) {
                                ForEach(viewModel.recipes) { recipe in
                                    NavigationLink(destination: RecipeView(recipe: recipe)) {
                                        RecipeCard(recipe: recipe)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.top, 10) // 고정 헤더와 컨텐츠 사이 여백 (Spacing between header and content)
                }
            }
            .navigationBarHidden(true)
            .background(Color(uiColor: .systemGroupedBackground))
            // 초기 데이터 로드 (Initial Data Load)
            .task {
                if viewModel.recipes.isEmpty {
                    await viewModel.fetchRecommendations()
                }
            }
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(FavoritesViewModel())
}
