import Foundation

// MARK: - API Response Models (API 응답 모델)

struct FoodSafetyResponse: Codable {
    let cookRcp01: CookRcp01?
    
    enum CodingKeys: String, CodingKey {
        case cookRcp01 = "COOKRCP01"
    }
}

struct CookRcp01: Codable {
    let totalCount: String
    let row: [FoodSafetyRecipe]?
    let result: ResultCode
    
    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case row
        case result = "RESULT"
    }
}

struct ResultCode: Codable {
    let msg: String
    let code: String
    
    enum CodingKeys: String, CodingKey {
        case msg = "MSG"
        case code = "CODE"
    }
}

// 식품안전나라 API 레시피 모델 (FoodSafetyKorea API Recipe Model)
// 식품안전나라 API 레시피 모델 (FoodSafetyKorea API Recipe Model)
struct FoodSafetyRecipe: Codable {
    let rcpSeq: String        // 레시피 일련번호 (Recipe Sequence)
    let rcpNm: String         // 메뉴명 (Menu Name)
    let rcpWay2: String       // 조리방법 (Cooking Method)
    let rcpPat2: String       // 요리종류 (Cuisine Type)
    let attFileNoMain: String // 메인 이미지 URL (Main Image URL)
    let attFileNoMk: String   // 메이킹 이미지 URL (Making Image URL)
    let rcpPartsDtls: String  // 재료 정보 (Ingredients Details)
    let infoEng: String       // 열량 (Calories) - INFO_ENG
    // 매뉴얼 내용 및 이미지 (Manual Steps and Images)
    let manual01: String?
    let manual02: String?
    let manual03: String?
    let manual04: String?
    let manual05: String?
    let manual06: String?
    let manual07: String?
    let manual08: String?
    let manual09: String?
    let manual10: String?
    let manual11: String?
    let manual12: String?
    let manual13: String?
    let manual14: String?
    let manual15: String?
    let manual16: String?
    let manual17: String?
    let manual18: String?
    let manual19: String?
    let manual20: String?
    let manualImg01: String?
    let manualImg02: String?
    let manualImg03: String?
    let manualImg04: String?
    let manualImg05: String?
    let manualImg06: String?
    let manualImg07: String?
    let manualImg08: String?
    let manualImg09: String?
    let manualImg10: String?
    let manualImg11: String?
    let manualImg12: String?
    let manualImg13: String?
    let manualImg14: String?
    let manualImg15: String?
    let manualImg16: String?
    let manualImg17: String?
    let manualImg18: String?
    let manualImg19: String?
    let manualImg20: String?
    
    enum CodingKeys: String, CodingKey {
        case rcpSeq = "RCP_SEQ"
        case rcpNm = "RCP_NM"
        case rcpWay2 = "RCP_WAY2"
        case rcpPat2 = "RCP_PAT2"
        case attFileNoMain = "ATT_FILE_NO_MAIN"
        case attFileNoMk = "ATT_FILE_NO_MK"
        case rcpPartsDtls = "RCP_PARTS_DTLS"
        case infoEng = "INFO_ENG"
        case manual01 = "MANUAL01"
        case manual02 = "MANUAL02"
        case manual03 = "MANUAL03"
        case manual04 = "MANUAL04"
        case manual05 = "MANUAL05"
        case manual06 = "MANUAL06"
        case manual07 = "MANUAL07"
        case manual08 = "MANUAL08"
        case manual09 = "MANUAL09"
        case manual10 = "MANUAL10"
        case manual11 = "MANUAL11"
        case manual12 = "MANUAL12"
        case manual13 = "MANUAL13"
        case manual14 = "MANUAL14"
        case manual15 = "MANUAL15"
        case manual16 = "MANUAL16"
        case manual17 = "MANUAL17"
        case manual18 = "MANUAL18"
        case manual19 = "MANUAL19"
        case manual20 = "MANUAL20"
        case manualImg01 = "MANUAL_IMG01"
        case manualImg02 = "MANUAL_IMG02"
        case manualImg03 = "MANUAL_IMG03"
        case manualImg04 = "MANUAL_IMG04"
        case manualImg05 = "MANUAL_IMG05"
        case manualImg06 = "MANUAL_IMG06"
        case manualImg07 = "MANUAL_IMG07"
        case manualImg08 = "MANUAL_IMG08"
        case manualImg09 = "MANUAL_IMG09"
        case manualImg10 = "MANUAL_IMG10"
        case manualImg11 = "MANUAL_IMG11"
        case manualImg12 = "MANUAL_IMG12"
        case manualImg13 = "MANUAL_IMG13"
        case manualImg14 = "MANUAL_IMG14"
        case manualImg15 = "MANUAL_IMG15"
        case manualImg16 = "MANUAL_IMG16"
        case manualImg17 = "MANUAL_IMG17"
        case manualImg18 = "MANUAL_IMG18"
        case manualImg19 = "MANUAL_IMG19"
        case manualImg20 = "MANUAL_IMG20"
    }
}

// MARK: - Domain Model (도메인 모델)

// 앱 내부에서 사용하는 레시피 모델 (Internal Recipe Model)
struct Recipe: Identifiable, Codable {
    let id: String           // 고유 ID (Unique ID)
    let title: String        // 제목 (Title)
    let category: String?    // 카테고리 (Category)
    let area: String?        // 지역 (Area - Not used currently)
    let instructions: String? // 조리법 설명 (Cooking Instructions)
    let thumbnail: String?   // 썸네일 이미지 URL (Thumbnail URL)
    let tags: String?        // 태그 (Tags - e.g. Cooking Method)
    let youtube: String?     // 유튜브 링크 (YouTube Link - Not used currently)
    let ingredients: [Ingredient]? // 재료 목록 (List of Ingredients)
    let calories: String?    // 칼로리 (Calories)
    
    // API 모델로부터 초기화 (Initializer from API Model)
    init(from apiRecipe: FoodSafetyRecipe) {
        self.id = apiRecipe.rcpSeq
        self.title = apiRecipe.rcpNm
        self.category = apiRecipe.rcpPat2
        self.area = nil // 새 API에서는 제공 안됨 (Not available in new API)
        // http를 https로 변환하여 ATS 문제 해결 (Convert http to https for ATS compliance)
        self.thumbnail = apiRecipe.attFileNoMain.replacingOccurrences(of: "http://", with: "https://")
        self.tags = apiRecipe.rcpWay2 // 조리 방법을 태그로 사용 (Using cooking method as tag)
        self.youtube = nil // 제공 안됨 (Not available)
        self.calories = apiRecipe.infoEng // 칼로리 정보 설정
        
        // 매뉴얼 합치기 (Combine manuals)
        var combinedInstructions = ""
        let manuals = [
            apiRecipe.manual01, apiRecipe.manual02, apiRecipe.manual03, apiRecipe.manual04, apiRecipe.manual05,
            apiRecipe.manual06, apiRecipe.manual07, apiRecipe.manual08, apiRecipe.manual09, apiRecipe.manual10,
            apiRecipe.manual11, apiRecipe.manual12, apiRecipe.manual13, apiRecipe.manual14, apiRecipe.manual15,
            apiRecipe.manual16, apiRecipe.manual17, apiRecipe.manual18, apiRecipe.manual19, apiRecipe.manual20
        ]
        
        for manual in manuals {
            if let text = manual, !text.isEmpty {
                combinedInstructions += text + "\n"
            }
        }
        self.instructions = combinedInstructions.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // 재료 파싱 (Parse ingredients)
        // 예시 포맷 (Format example): "북어채 25g(15개), 새우 10g(3마리), 사과 30g(1/5개)..."
        // 간단한 파서를 사용하며 개선이 필요할 수 있음 (Simple parser, might need refinement)
        let parts = apiRecipe.rcpPartsDtls.components(separatedBy: ",")
        self.ingredients = parts.map { part in
            let trimmed = part.trimmingCharacters(in: .whitespacesAndNewlines)
            // 휴리스틱: 전체를 이름으로 사용 (Heuristic: Use entire string as name for now)
            return Ingredient(name: trimmed, measure: "")
        }
    }
    
    // 프리뷰 등을 위한 초기화 헬퍼 (Helper for manual initialization e.g. previews)
    init(id: String, title: String, thumbnail: String?, instructions: String?, ingredients: [Ingredient]?, category: String? = nil, calories: String? = nil) {
        self.id = id
        self.title = title
        self.thumbnail = thumbnail
        self.instructions = instructions
        self.ingredients = ingredients
        self.category = category
        self.area = nil
        self.tags = nil
        self.youtube = nil
        self.calories = calories
    }
}
