
import SwiftUI

// The puzzle categories present in the game

struct Category: Identifiable, Equatable {
    
    // -----------------
    // Static Properties
    // -----------------
    
    // A list of all the categories in the game
    static var categories: [Category] {
        return Bundle.main.decodeCategories("Index.txt")
    }
    
    // A list of all the free categories in the game
    static var freeCategories: [Category] {
        return Array(categories.prefix(DomingoEngine.freeCategoriesCount))
    }
    
    // A list of all the paid categories in the game
    static var paidCategories: [Category] {
        return Array(categories.suffix(from: DomingoEngine.freeCategoriesCount))
    }
    
    // The total number of category questions in the app
    static var totalQuestionsCount: Int {
        var i = 0
        for category in categories {
            i += category.questions.count
        }
        return i
    }
    
    // The category associated with a given seed
    public static func categoryForSeed(_ seed: Int) -> Category {
        return categories.filter({$0.questions.count > 0}).randomElementBySeed(seed)!
    }
    
    // Equatable conformance
    static func == (lhs: Category, rhs: Category) -> Bool {
        return lhs.name == rhs.name
    }
    
    // -----------------
    // Stored Properties
    // -----------------
    
    // A unique ID for the category
    let id: UUID = UUID()
    
    // The category name
    let name: String
    
    // The array of questions belonging to this category
    let questions: [Question]

    // The name of the SF symbol used to represent this category
    let symbolName: String
}
