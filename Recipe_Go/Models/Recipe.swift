import Foundation

// MARK: - API Response Models

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

struct FoodSafetyRecipe: Codable {
    let rcpSeq: String
    let rcpNm: String
    let rcpWay2: String
    let rcpPat2: String
    let attFileNoMain: String
    let attFileNoMk: String
    let rcpPartsDtls: String
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

// MARK: - Domain Model

struct Recipe: Identifiable, Codable {
    let id: String
    let title: String
    let category: String?
    let area: String?
    let instructions: String?
    let thumbnail: String?
    let tags: String?
    let youtube: String?
    let ingredients: [Ingredient]?
    
    // Initializer to convert from API model
    init(from apiRecipe: FoodSafetyRecipe) {
        self.id = apiRecipe.rcpSeq
        self.title = apiRecipe.rcpNm
        self.category = apiRecipe.rcpPat2
        self.area = nil // Not available in new API
        self.thumbnail = apiRecipe.attFileNoMain.replacingOccurrences(of: "http://", with: "https://")
        self.tags = apiRecipe.rcpWay2 // Using cooking method as tag
        self.youtube = nil // Not available
        
        // Combine manuals
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
        
        // Parse ingredients
        // Format example: "북어채 25g(15개), 새우 10g(3마리), 사과 30g(1/5개)..."
        // This is a simple parser, might need refinement
        let parts = apiRecipe.rcpPartsDtls.components(separatedBy: ",")
        self.ingredients = parts.map { part in
            let trimmed = part.trimmingCharacters(in: .whitespacesAndNewlines)
            // Heuristic: Split by space, last part might be measure?
            // Or just put everything in name for now as it's hard to separate perfectly without NLP
            return Ingredient(name: trimmed, measure: "")
        }
    }
    
    // Helper for manual initialization (e.g. previews)
    init(id: String, title: String, thumbnail: String?, instructions: String?, ingredients: [Ingredient]?, category: String? = nil) {
        self.id = id
        self.title = title
        self.thumbnail = thumbnail
        self.instructions = instructions
        self.ingredients = ingredients
        self.category = category
        self.area = nil
        self.tags = nil
        self.youtube = nil
    }
}
