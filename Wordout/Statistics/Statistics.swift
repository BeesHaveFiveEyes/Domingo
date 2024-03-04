
import Foundation

// A class used to store statistics about the user's progress in the puzzles and to calculate further statistics from these

class Statistics {
    
    // ---------------------
    // User Defaults Storage
    // ---------------------
    
    // How many guesses, in total, has the user ever submitted?
    static let guesses = StoredInteger(key: "TOTALGUESSES")
    
    // How many daily puzzles has the user ever completed?
    static let dailyPuzzlesCompleted = StoredInteger(key: "TOTALCOMPLETIONS")
    
    // How many archived puzzles has the user ever completed?
    static let archivedPuzzlesCompleted = StoredInteger(key: "TOTALARCHIVEDCOMPLETIONS")
    
    // How many daily puzzles has the user ever attempted?
    static let dailyPuzzlesAttempted = StoredInteger(key: "TOTALATTEMPTS")
    
    // The user's current streak
    static let currentStreak = StoredInteger(key: "CURRENTSTREAK")
    
    // The user's longest ever recorded streak
    static let longestStreak = StoredInteger(key: "LONGESTSTREAK")
    
    // The last seed for which the user completed a daily puzzle
    static let lastCompletedSeed = StoredInteger(key: "LASTCOMPLETION")
    
    // The last seed for which the user attempted a daily puzzle
    static let lastAttemptedSeed = StoredInteger(key: "LASTATTEMPT")
    
    // Has the user seen the instructions?
    static let userHasSeenInstructions = StoredBoolean(key: "INSTRUCTIONSSEEN")
    
    // ---------
    // Functions
    // ---------
    
    // Record an attempt of the daily puzzle
    static func logDailyAttempt() {
        if Date().seed != lastAttemptedSeed.value {
            dailyPuzzlesAttempted.increment()
            lastAttemptedSeed.replace(with: Date().seed)
        }
    }
    
    // Record a completion of the daily puzzle
    static func logDailyPuzzleCompletion() {
                
        if Date().seed != lastCompletedSeed.value {
            
            // Handle Streak
            if Date().seed == lastCompletedSeed.value + 1 {
                currentStreak.increment()
            }
            else {
                currentStreak.replace(with: 1)
            }
            
            if currentStreak.value > longestStreak.value {
                longestStreak.replace(with: currentStreak.value)
            }
            
            dailyPuzzlesCompleted.increment()
            lastCompletedSeed.replace(with: Date().seed)
        }
    }
    
    // Record a completion of an archived puzzle
    static func logArchivedPuzzleCompletion() {
        archivedPuzzlesCompleted.increment()
    }
    
    // Check whether the player has missed their streak yesterday
    static func checkForMissedStreak() {
        if Date().seed > lastCompletedSeed.value + 1 {
            currentStreak.replace(with: 0)
        }
    }
    
    // Reset all the stored statistics
    public static func resetAll() {
        guesses.replace(with: 0)
        dailyPuzzlesCompleted.replace(with: 0)
        archivedPuzzlesCompleted.replace(with: 0)
        dailyPuzzlesAttempted.replace(with: 0)
        currentStreak.replace(with: 0)
        longestStreak.replace(with: 0)
    }
    
    // -------------------
    // Computed Properties
    // -------------------
    
    // The proportion of daily puzzles attempted that were completed
    public static var successRate: Int? {
        let completed = dailyPuzzlesCompleted.value
        let attempted = dailyPuzzlesAttempted.value
        if attempted == 0 {
            return nil
        }
        return Int(100 * completed / attempted)
    }
        
    // The total number of questions in the categories view that have been completed
    public static var totalCategoryQuestionsCompleted: Int {
        var i = 0
        for category in Category.categories {
            let puzzle = DomingoEngine.loadCategoryPuzzle(category)
            for question in puzzle.questions {
                if puzzle.progress[question] ?? false {
                    i += 1
                }
            }
        }
        return i
    }
    
    // The total number of questions in the categories view
    public static var totalCategoryQuestions: Int {
        var i = 0
        for category in Category.categories {
            i += category.questions.count
        }
        return i
    }
    
    // The total number of categories in the categories view that have been completed
    public static var totalCategoriesCompleted: Int {
        var i = 0
        for category in Category.categories {
            let puzzle = DomingoEngine.loadCategoryPuzzle(category)
            if puzzle.completed && puzzle.questions.count > 0 {
                i += 1
            }
        }
        return i
    }
    
    // The total number of categories in the categories view
    public static var totalCategories: Int {
        return Category.categories.filter({$0.questions.count > 0}).count
    }
    
    // The percentage of questions in the categories view that have been completed
    public static var categoryQuestionCompletionPercentage: Int {
        return Int(100 * totalCategoryQuestionsCompleted / totalCategoryQuestions)
    }
    
    // The percentage of categories in the categories view that have been completed
    public static var categoryCompletionPercentage: Int {
        return Int(100 * totalCategoriesCompleted / totalCategories)
    }
}
