//
//  Structure.swift
//  Wordout
//
//  Created by Alasdair Casperd on 04/11/2022.
//

import SwiftUI

struct Category: Identifiable {
    
    let id: UUID = UUID()
    let name: String
    let description: String?
    let questions: [Question]
    let symbolName: String
    let emoji: String
    var custom: Bool = false
    
    var puzzle: Puzzle {
        return Puzzle(name: name, description: nil, questions: questions, symbolName: symbolName, emoji: emoji, dailyStyle: false, custom: custom)
    }
    
    static var premadeCategories: [Category] {
        return Bundle.main.decodeCategories("Index.txt")
    }
    
    static var freeCategories: [Category] {
        return Array(premadeCategories.prefix(WordoutApp.freePuzzles))
    }
    
    static var paidCategories: [Category] {
        return Array(premadeCategories.suffix(from: WordoutApp.freePuzzles))
    }
    
    static var example: Category {
        
        var questions = [Question]()
        
        questions.append(Question(id: 0, container: "canopied", insert: "pie"))
        questions.append(Question(id: 1, container: "arpeggio", insert: "egg"))
        questions.append(Question(id: 2, container: "impeachment", insert: "peach"))
        questions.append(Question(id: 3, container: "matrices", insert: "rice"))
        questions.append(Question(id: 4, container: "fortunate", insert: "tuna"))
        questions.append(Question(id: 5, container: "wastewater", insert: "stew"))
        questions.append(Question(id: 6, container: "sobriety", insert: "brie"))
        questions.append(Question(id: 7, container: "temperament", insert: "ramen"))
        
        return Category(name: "Food", description: nil, questions: questions, symbolName: "carrot", emoji: "🍔", custom: false)
    }
}

class Puzzle {
    
    let id: UUID = UUID()
    let name: String
    let description: String?
    let symbolName: String
    let emoji: String
    let dailyStyle: Bool
    let custom: Bool = false
    
    var questions: [Question]
    
    public static let dailyPuzzleLength = 4
    
    private static var todaysSeed: Int {
        return Date().seed
    }
    
    private static func categoryForSeed(_ seed: Int) -> Category {
        return SeededRandomnessEngine.seededChoice(Category.premadeCategories.filter({$0.questions.count > 0}), seed: seed)!
    }
    
    func loadingFromCategoryProgress() -> Puzzle {
        let newQuestions = questions
        for q in newQuestions {
            q.guessed = UserDefaults.standard.bool(forKey: Progress.key(for: q, in: self))
        }
        return Puzzle(name: name, description: description, questions: newQuestions, symbolName: symbolName, emoji: emoji, dailyStyle: dailyStyle)
    }
    
    func loadingFromDailyProgress() -> Puzzle {
        
        print("loadingFromDailyProgress() called")
        
        let newQuestions = questions
        
        print("Current seed: \(Date().seed)")
        print("Last seen seed: \(Progress.lastSeenSeed)")
        
        if Progress.lastSeenSeed == Date().seed {
            print("lastSeenSeed in UserDefaults matches the current seed. Attempting to load saved progress.")
            for q in newQuestions {
                let key = Progress.key(for: q, in: self)
                let storedValue = UserDefaults.standard.bool(forKey: key)
                q.guessed = storedValue
                print("Reading '\(storedValue)' from key '\(key)'")
            }
        }
        else {
            print("lastSeenSeed found in UserDefaults does not match the current seed. Resetting progress.")
            for q in newQuestions {
                q.guessed = false
                let key = Progress.key(for: q, in: self)
                let value = false
                UserDefaults.standard.set(value, forKey: key)
                print("Setting key '\(key)' to '\(value)'")
            }
        }
        
        Progress.storeLastSeed()
        
        return Puzzle(name: name, description: description, questions: newQuestions, symbolName: symbolName, emoji: emoji, dailyStyle: dailyStyle)
    }
    
    static var dailyPuzzle: Puzzle {
        return puzzleForDate(Date())
    }
    
    static func puzzleForDate(_ date: Date) -> Puzzle {
        let seed = date.seed
        let category = categoryForSeed(seed)
        let shuffledOptions = SeededRandomnessEngine.seededShuffle(category.questions, seed: seed)
        let questions = Question.fixIDs(questions: Array(shuffledOptions.prefix(dailyPuzzleLength)))
        return Puzzle(name: category.name, description: category.description, questions: questions, symbolName: category.symbolName, emoji: category.emoji, dailyStyle: true)
    }
    
    init(name: String, description: String?, questions: [Question], symbolName: String, emoji: String, dailyStyle: Bool, custom: Bool = false) {
        self.name = name
        self.description = description
        self.questions = questions
        self.symbolName = symbolName
        self.emoji = emoji
        self.dailyStyle = dailyStyle
    }
    
    func correctlyGuess(_ question: Question) {
        var newQuestions = [Question]()
        for q in questions {
            if q == question {
                q.guessed = true
            }
            newQuestions.append(q)
        }
        questions = newQuestions
    }
    
    var totalGuessed: Int {
        return questions.filter({ $0.guessed }).count
    }
    
    var completed: Bool {
        return totalGuessed == questions.count
    }
}

class Question: Identifiable, Equatable {
    
    static func == (lhs: Question, rhs: Question) -> Bool {
        return lhs.id == rhs.id
    }
    
    // Relabels the ID's of a list of questions to be 0,...,n for some n
    static func fixIDs(questions: [Question]) -> [Question] {
        var output = [Question]()
        var i = 0
        for question in questions {
            let q = Question(id: i, container: question.container, insert: question.insert)
            output.append(q)
            i += 1
        }
        return output
    }
    
    let id: Int
    let container: String
    let insert: String
    
    var guessed: Bool = false
    
    var clue: String {
        return left.capitalized + " \(WordoutApp.placeholder) " + right
    }
    
    var formattedInsert: String {
        return left == "" ? insert.lowercased().capitalized : insert.lowercased()
    }
    
    var left: String {
        let components = (" " + container + " ").components(separatedBy: insert).filter({ $0.count > 0 })
        if components.count < 2 {
            fatalError("Invalid question: Container \'\(container)\' does not contain \"\(insert)\"")
        }
        else {
            let l = components[0].filter({!($0 == " ")})
            return l
        }
    }
    
    var right: String {
        let components = (" " + container + " ").components(separatedBy: insert).filter({ $0.count > 0 })
        if components.count < 2 {
            fatalError("Invalid question: Container \'\(container)\' does not contain \"\(insert)\"")
        }
        else {
            let r = components[1].filter({!($0 == " ")})
            return r
        }
    }
    
    var explicitAnswer: String {
        return left + "-" + insert + "-" + right
    }
    
    init(id: Int, container: String, insert: String, guessed: Bool) {
        self.id = id
        self.container = container
        self.insert = insert
        self.guessed = guessed
    }
    
    init(id: Int, container: String, insert: String) {
        self.id = id
        self.container = container
        self.insert = insert
        self.guessed = false
    }
}

struct SeededRandomnessEngine {
    
    struct SeededRandomNumberGenerator: RandomNumberGenerator {
        
        init(seed: Int) {
            srand48(seed)
        }
        
        func next() -> UInt64 {
            return UInt64(drand48() * Double(UInt64.max))
        }
    }

    
    static func seededChoice<T>(_ collection: [T], seed: Int) -> T? {
        
        var seededGenerator = SeededRandomNumberGenerator(seed: seed)
        
        if  collection.count > 0 {
            return collection.randomElement(using: &seededGenerator)
        }
        else {
            return nil
            
        }
    }
    
    static func seededShuffle<T>(_ collection: [T], seed: Int) -> [T] {
        
        var seededGenerator = SeededRandomNumberGenerator(seed: seed)
        return collection.shuffled(using: &seededGenerator)
    }
    
}
