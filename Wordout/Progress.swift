//
//  Progress.swift
//  Wordout
//
//  Created by Alasdair Casperd on 09/11/2022.
//

import SwiftUI

class Progress {
    
    private static let dailyPath = "DAILY"
    private static let categoriesPath = "CATEGORIES"
    
    static let lastCompletedSeed = StoredInteger(key: "LASTCOMPLETION")
    static let lastAttemptedSeed = StoredInteger(key: "LASTATTEMPT")
    
    static func loadStoredPuzzle(for puzzle: Puzzle) -> Puzzle {
        
        let newQuestions = puzzle.questions
        
        if !puzzle.dailyStyle || Progress.lastAttemptedSeed.value == Date().seed {
            for q in newQuestions {
                let key = Progress.key(for: q, in: puzzle)
                let storedValue = UserDefaults.standard.bool(forKey: key)
                q.guessed = storedValue
            }
        }
        else {
            for q in newQuestions {
                q.guessed = false
                let key = Progress.key(for: q, in: puzzle)
                let value = false
                UserDefaults.standard.set(value, forKey: key)
            }
        }
        
        return Puzzle(name: puzzle.name, description: puzzle.description, questions: newQuestions, symbolName: puzzle.symbolName, emoji: puzzle.emoji, dailyStyle: puzzle.dailyStyle)
    }
    
    public static func key(for question: Question, in puzzle: Puzzle) -> String {
        
        if puzzle.dailyStyle {
            if question.id < Puzzle.dailyPuzzleLength {
                return "\(dailyPath)/\(question.id)"
            }
            else {
                fatalError("Daily puzzle id out of range for storing in UserDefaults")
            }
        }
        else if puzzle.custom {
            fatalError("This function does not support custom categories.")
        }
        else {
            return "\(categoriesPath)/\(puzzle.name.uppercased())/\(question.container.uppercased())"
        }
    }
    
    public static func storeProgress(puzzle: Puzzle) {
        if puzzle.dailyStyle {
            var i = 0
            for question in puzzle.questions {
                let key = key(for: question, in: puzzle)
                let value = question.guessed
                UserDefaults.standard.set(value, forKey: key)
                i += 1
            }
        }
        else {
            for question in puzzle.questions {
                let key = key(for: question, in: puzzle)
                let value = question.guessed
                UserDefaults.standard.set(value, forKey: key)
            }
        }
    }
    
    static func resetAll() {
        
        for category in Category.premadeCategories {
            
            var puzzle  = category.puzzle
            
            let newQuestions = puzzle.questions
            
            for question in newQuestions {
                question.guessed = false
            }
            
            puzzle = Puzzle(name: puzzle.name, description: puzzle.description, questions: newQuestions, symbolName: puzzle.symbolName, emoji: puzzle.emoji, dailyStyle: puzzle.dailyStyle)
            
            Progress.storeProgress(puzzle: puzzle)
        }
    }
}
