//
//  File.swift
//  Wordout
//
//  Created by Alasdair Casperd on 09/11/2022.
//

import Foundation

class Progress {
    
    private static let dailyPath = "DAILY"
    private static let categoriesPath = "CATEGORIES"
    
    public static func key(for question: Question, in puzzle: Puzzle) -> String {
        
        if puzzle.dailyStyle {
            if question.id < Puzzle.dailyPuzzleLength {
                return "\(dailyPath)/\(puzzle.name.uppercased())/\(question.id)"
            }
            else {
                fatalError("Daily puzzle id out of range for storing in UserDefaults")
            }
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
}
