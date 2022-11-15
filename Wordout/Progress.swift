//
//  File.swift
//  Wordout
//
//  Created by Alasdair Casperd on 09/11/2022.
//

import SwiftUI

class Progress {
    
    private static let dailyPath = "DAILY"
    private static let categoriesPath = "CATEGORIES"
    private static let customCategoriesPath = "CUSTOM"
    private static let datePath = "DATE"
    
    public static func key(for question: Question, in puzzle: Puzzle) -> String {
        
        if puzzle.dailyStyle {
            if question.id < Puzzle.dailyPuzzleLength {
                return "\(dailyPath)/\(puzzle.name.uppercased())/\(question.id)"
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
    
    public static func storeLastSeed() {
        let key = datePath
        let value = Date().seed
        UserDefaults.standard.set(value, forKey: key)
    }
    
    public static var lastSeenSeed: Int {
        return UserDefaults.standard.integer(forKey: datePath)
    }
    
    public static func storeProgress(puzzle: Puzzle) {
        if puzzle.dailyStyle {
            var i = 0
            for question in puzzle.questions {
                let key = key(for: question, in: puzzle)
                let value = question.guessed
//                print("\(key) -> \(value)")
                UserDefaults.standard.set(value, forKey: key)
                i += 1
            }
        }
        else {
            for question in puzzle.questions {
                let key = key(for: question, in: puzzle)
                let value = question.guessed
//                print("\(key) -> \(value)")
                UserDefaults.standard.set(value, forKey: key)
            }
        }
    }
    
    public static func storeCustomPuzzle(_ category: Category, id: Int) {
        if id < 3 {
            UserDefaults.standard.set(category.name, forKey: "\(customCategoriesPath)/STORAGE/\(id)/NAME")
            UserDefaults.standard.set(category.description ?? "", forKey: "\(customCategoriesPath)/STORAGE/\(id)/DESCRIPTION")
            UserDefaults.standard.set(category.description ?? "", forKey: "\(customCategoriesPath)/STORAGE/\(id)/EMOJI")
            
            var inserts = ""
            var containers = ""
            
            for question in category.questions {
                inserts += question.insert + "\n"
                containers += question.container + "\n"
            }
            
            UserDefaults.standard.set(inserts, forKey: "\(customCategoriesPath)/STORAGE/\(id)/INSERTS")
            UserDefaults.standard.set(containers, forKey: "\(customCategoriesPath)/STORAGE/\(id)/CONTAINERS")
        }
        else {
            fatalError("Attempting to add too many categories.")
        }
    }
    
    public static func readCustomPuzzle(_ id: Int) -> Category {
        if id < 3 {
                                    
            let name = UserDefaults.standard.string(forKey: "\(customCategoriesPath)/STORAGE/\(id)/NAME")!
            let description = UserDefaults.standard.string(forKey: "\(customCategoriesPath)/STORAGE/\(id)/DESCRIPTION")!
            let emoji = UserDefaults.standard.string(forKey: "\(customCategoriesPath)/STORAGE/\(id)/EMOJI")!
            
            let inserts = UserDefaults.standard.string(forKey: "\(customCategoriesPath)/STORAGE/\(id)/INSERTS")!.components(separatedBy: "\n")
            let containers = UserDefaults.standard.string(forKey: "\(customCategoriesPath)/STORAGE/\(id)/CONTAINERS")!.components(separatedBy: "\n")
            
            var questions = [Question]()
            
            for i in 0...(inserts.count - 1) {
                questions.append(Question(id: i, container: containers[i], insert: inserts[i]))
            }
                        
            return Category(name: name, description: description, questions: questions, symbolName: "", emoji: emoji)
        }
        else {
            fatalError("Attempting to add load category with invalid index.")
        }
    }
    
    // STATISTICS
    
    public static func logGuess() {
        var guesses = UserDefaults.standard.integer(forKey: "TOTALGUESSES")
        guesses += 1
        UserDefaults.standard.set(guesses, forKey: "TOTALGUESSES")
    }
    
    public static var totalGuesses: Int {
        UserDefaults.standard.integer(forKey: "TOTALGUESSES")
    }
    
    // Completion stats
    
    public static func logDailyCompletion() {
        if Date().seed != lastCompletionSeed {
            var completions = UserDefaults.standard.integer(forKey: "TOTALCOMPLETIONS")
            completions += 1
            UserDefaults.standard.set(completions, forKey: "TOTALCOMPLETIONS")
        }
        storeLastAttemptSeed()
    }
    
    public static var completions: Int {
        return UserDefaults.standard.integer(forKey: "TOTALCOMPLETIONS")
    }
    
    private static func storeLastCompletionSeed() {
        let key = "LASTCOMPLETION"
        let value = Date().seed
        UserDefaults.standard.set(value, forKey: key)
    }
    
    private static var lastCompletionSeed: Int {
        return UserDefaults.standard.integer(forKey: "LASTCOMPLETION")
    }
    
    // Attempt stats
    
    public static func logDailyAttempt() {
        if Date().seed != lastAttemptSeed {
            var attempts = UserDefaults.standard.integer(forKey: "TOTALATTEMPTS")
            attempts += 1
            UserDefaults.standard.set(attempts, forKey: "TOTALATTEMPTS")
        }
        storeLastAttemptSeed()
    }
    
    public static var attempts: Int {
        return UserDefaults.standard.integer(forKey: "TOTALATTEMPTS")
    }
    
    private static func storeLastAttemptSeed() {
        let key = "LASTATTEMPT"
        let value = Date().seed
        UserDefaults.standard.set(value, forKey: key)
    }
    
    private static var lastAttemptSeed: Int {
        return UserDefaults.standard.integer(forKey: "LASTATTEMPT")
    }
    
    // Settings
    
    // Harmode setting store via @AppStorage
    
    public static var hardModeOn: Bool {
        let key = "HARDMODE"
        return UserDefaults.standard.bool(forKey: key)
    }
    
}
