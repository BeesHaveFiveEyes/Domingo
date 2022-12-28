//
//  Statistics.swift
//  Wordout
//
//  Created by Alasdair Casperd on 26/11/2022.
//

import Foundation


class Statistics {
    
    // Stored Integers
    
    static let guesses = StoredInteger(key: "TOTALGUESSES")
    static let dailyPuzzlesCompleted = StoredInteger(key: "TOTALCOMPLETIONS")
    static let dailyPuzzlesAttempted = StoredInteger(key: "TOTALATTEMPTS")
    static let streak = StoredInteger(key: "CURRENTSTREAK")
    static let longestStreak = StoredInteger(key: "LONGESTSTREAK")
    
    // Daily Statistics
    
    static func logDailyAttempt() {
        print("Checking for need to log daily attempt")
        if Date().seed != Progress.lastAttemptedSeed.value {
            print("Logging daily attempt")
            Statistics.dailyPuzzlesAttempted.increment()
            Progress.lastAttemptedSeed.replace(with: Date().seed)
        }
    }
    
    static func logDailyCompletion() {
        
        // If not already completed today
        if Date().seed != Progress.lastCompletedSeed.value {
            
            // Handle Streak
            if Date().seed == Progress.lastCompletedSeed.value + 1 {
                streak.increment()
            }
            else {
                streak.replace(with: 1)
            }
            
            if streak.value > longestStreak.value {
                longestStreak.replace(with: streak.value)
            }
            
            Statistics.dailyPuzzlesCompleted.increment()
            Progress.lastCompletedSeed.replace(with: Date().seed)
        }
    }
    
    static func checkStreak() {
        if Date().seed > Progress.lastCompletedSeed.value + 1 {
            streak.replace(with: 0)
        }
    }
    
    // Categories Statistics
    
    public static var questionsCompleted: Int {
        var i = 0
        for category in Category.premadeCategories {
            for question in Progress.loadStoredPuzzle(for: category.puzzle).questions {
                if question.guessed {
                    i += 1
                }
            }
        }
        return i
    }
    
    public static var totalQuestions: Int {
        var i = 0
        for category in Category.premadeCategories {
            i += category.questions.count
        }
        return i
    }
    
    public static var categoriesCompleted: Int {
        var i = 0
        for category in Category.premadeCategories {
            let puzzle = Progress.loadStoredPuzzle(for: category.puzzle)
            if puzzle.completed && puzzle.questions.count > 0 {
                i += 1
            }
        }
        return i
    }
    
    public static var totalCategories: Int {
        return Category.premadeCategories.filter({$0.questions.count > 0}).count
    }
    
    public static var questionCompletionPercentage: Int {
        return Int(100 * questionsCompleted / totalQuestions)
    }
    
    public static var categoryCompletionPercentage: Int {
        return Int(100 * categoriesCompleted / totalCategories)
    }
    
    public static var successRate: Int? {
        let completed = Statistics.dailyPuzzlesCompleted.value
        let attempted = Statistics.dailyPuzzlesAttempted.value
        if attempted == 0 {
            return nil
        }
        return Int(100 * completed / attempted)
    }

    // Reset
    
    public static func resetAll() {
        
        guesses.replace(with: 0)
        dailyPuzzlesCompleted.replace(with: 0)
        dailyPuzzlesAttempted.replace(with: 0)
        streak.replace(with: 0)
        longestStreak.replace(with: 0)
    }
    
}
