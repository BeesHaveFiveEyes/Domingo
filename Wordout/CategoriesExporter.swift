//
//  CategoriesExport.swift
//  Wordout
//
//  Created by Alasdair Casperd on 01/01/2023.
//

import Foundation

func exportDailyPuzzles() -> String {
    
    let startSeed = 0
    let endSeed = 3650*2
    
    let pDelimeter = "/"
    let qDelimeter = "."
    
    var output = ""
    
    for i in startSeed...endSeed {
        var l = ""
        let puzzle = Puzzle.puzzleForDate(Date.dateForSeed(i))
        let category = Puzzle.categoryForSeed(i)
        l += "\(Int(Category.premadeCategories.firstIndex(of: category)!))"
        for question in puzzle.questions {
            l += qDelimeter
            var j = 0
            var passed = false
            for originalQ in category.questions {
                if question.explicitAnswer == originalQ.explicitAnswer {
                    j = originalQ.id - 1
                    passed = true
                    break
                }
            }
            if passed {
                l += "\(j)"
            }
            else {
                print("i == \(i)")
                print("l == \(l)")
                fatalError("Error A in exportDailyPuzzles()")
            }
        }
        l += pDelimeter
        output += l
    }
    
    return output
}
