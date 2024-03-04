
import SwiftUI

// Responsible for generating the puzzles used in the game and storing the user's progress

struct DomingoEngine {
    
    // -----------------
    // Static Properties
    // -----------------
    
    // The number of categories playable for free in the game
    static let freeCategoriesCount = 4
    
    // The length of all daily-style puzzles
    static let dailyPuzzleLength = 4
    
    // The name of the app
    static public let appName = "Domingo"
    
    // The placeholder symbol used throughout the app's puzzles
    static let placeholder = "❖"
    
    // The app's theme color
    static public let themeColor = Color("ThemeColor")
    
    // A background color used in many of the app's views
    static public let backgroundColor = Color(UIColor.systemGroupedBackground)
    
    // Paths for progress storage
    private static let dailyPath = "DAILY"
    private static let categoriesPath = "CATEGORIES"
    
    // ----------------
    // Static Functions
    // ----------------
    
    // Generate a random daily-style puzzle of the specified length
    
    static func newRandomPuzzle(length n: Int = dailyPuzzleLength) -> Puzzle {
        
        // Choose a category at random
        let category = Category.categories.randomElement()!
        
        // Choose the n questions at random from this category
        let questions = Array(category.questions.shuffled().prefix(n))
        
        // Create the puzzle
        return Puzzle(category: category, questions: questions)
    }
    
    // Create the daily puzzle for the specified date
    
    static func newPuzzleForDate(_ date: Date) -> Puzzle {
        
        // Access the seed associated with the input date
        let seed = date.seed
        
        // Return the puzzle
        return newPuzzleForSeed(seed)
    }
    
    // Create the daily puzzle for the specified seed
    
    static func newPuzzleForSeed(_ seed: Int) -> Puzzle {
        
        // Access the category associated with this seed
        let category = Category.categoryForSeed(seed)
        
        // Choose the questions according to a seeded random shuffle
        let questions = Array(category.questions.shuffledBySeed(seed).prefix(dailyPuzzleLength))
        
        // Create the puzzle
        return Puzzle(category: category, questions: questions, seed: seed)
    }
    
    // Create a puzzle using all the questions from a specified category
    
    static func newPuzzleFromCategory(_ category: Category) -> Puzzle {
        
        // Access the category's questions
        let questions = category.questions
        
        // Create the puzzle
        return Puzzle(category: category, questions: questions)
    }
    
    
    // Create a new copy of today's daily puzzle
    
    static func newCopyOfTodaysPuzzle() -> Puzzle {
        return newPuzzleForDate(Date())
    }
    
    // Load today's daily puzzle, loading any completed questions
    
    static func loadTodaysPuzzle() -> Puzzle {
        
        let output = newPuzzleForDate(Date())
        
        // Check if the last attempted daily puzzle was today's puzzle
        if Statistics.lastAttemptedSeed.value == Date().seed {
            
            // If so, load the stored progress
            var i = 0
            for question in output.questions {
                let key = "\(dailyPath)/\(i)"
                output.progress[question] = UserDefaults.standard.bool(forKey: key)
                i += 1
            }
        }
        else {
            
            // Otherwise, clear the stored progress
            var i = 0
            for _ in output.questions {
                let key = "\(dailyPath)/\(i)"
                UserDefaults.standard.set(false, forKey: key)
                i += 1
            }
        }
        
        return output
    }
    
    // Load the puzzle for a particular category, loading any completed questions
    
    static func loadCategoryPuzzle(_ category: Category) -> Puzzle {
        
        let output = newPuzzleFromCategory(category)
        
        for question in output.questions {
            let key = categoryKeyFor(question, in: output.category)
            output.progress[question] = UserDefaults.standard.bool(forKey: key)
        }
        
        return output
    }
    
    // Save the user's progress in a given daily puzzle
    
    static func storeDailyPuzzle(_ puzzle: Puzzle) {
        
        Statistics.lastAttemptedSeed.replace(with: Date().seed)
                
        var i = 0
        for question in puzzle.questions {
            let key = "\(dailyPath)/\(i)"
            UserDefaults.standard.set(puzzle.progress[question], forKey: key)
            i += 1
        }
        
    }
    
    // Save the user's progress in solving a category puzzle
    
    static func storeCategoryPuzzle(_ puzzle: Puzzle) {
        for question in puzzle.questions {
            let key = categoryKeyFor(question, in: puzzle.category)
            let value = puzzle.progress[question] ?? false
            UserDefaults.standard.set(value, forKey: key)
        }
    }
    
    // Reset the user's progress in solving the categories
    
    static func resetCategoryProgress() {
        for category in Category.categories {
            storeCategoryPuzzle(newPuzzleFromCategory(category))
        }
    }
    
    // -------------------
    // Computed Properties
    // -------------------
    
    // Has the daily puzzle been started?
    static var dailyPuzzleInProgress: Bool {
        return loadTodaysPuzzle().totalQuestionsGuessed > 0
    }
    
    // Has the daily puzzle been completed?
    static var dailyPuzzleCompleted: Bool {
        return loadTodaysPuzzle().completed
    }

    // ----------------
    // Helper Functions
    // ----------------
    
    private static func categoryKeyFor(_ question: Question, in category: Category) -> String {
        return "\(categoriesPath)/\(category.name.uppercased())/\(question.container.uppercased())"
    }
}
