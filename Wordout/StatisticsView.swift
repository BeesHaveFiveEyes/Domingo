//
//  StatisticsView.swift
//  Wordout
//
//  Created by Alasdair Casperd on 12/11/2022.
//

import SwiftUI

struct StatisticsView: View {
    
    private let playMode = PlayMode.statistics
    
    private var categoriesCompleted: Int {
        var i = 0
        for category in Category.premadeCategories {
            let puzzle = category.puzzle.loadingFromCategoryProgress()
            if puzzle.completed && puzzle.questions.count > 0 {
                i += 1
            }
        }
        return i
    }
    
    private var totalCategories: Int {
        return Category.premadeCategories.filter({$0.questions.count > 0}).count
    }
    
    private var questionsCompleted: Int {
        var i = 0
        for category in Category.premadeCategories {
            for question in category.puzzle.loadingFromCategoryProgress().questions {
                if question.guessed {
                    i += 1
                }
            }
        }
        return i
    }
    
    private var overallCompletionPercent: Int {
        return Int(100 * questionsCompleted / totalQuestions)
    }
    
    private var totalQuestions: Int {
        var i = 0
        for category in Category.premadeCategories {
            i += category.questions.count
        }
        return i
    }
    
    public var successRate: Int? {
        if Progress.attempts == 0 {
            return nil
        }
        return Int(100 * Progress.completions / Progress.attempts)
    }
    
    var body: some View {
        Form {
            Section(header: Text("Daily Puzzles")) {
                Statistic(name: "Daily Puzzles Completed", detail: "\(Progress.completions)", symbolName: "calendar")
                Statistic(name: "Success Rate", detail: successRate == nil ? "N/A" : "\(successRate!)%", symbolName: "scope")
            }
            
            Section(header: Text("Categories")) {
                Statistic(name: "Categories Completed", detail: "\(categoriesCompleted) / \(totalCategories)", symbolName: "archivebox")
                Statistic(name: "Overall Completion", detail: "\(overallCompletionPercent)%", symbolName: "checkmark.circle")
            }
            
            Section(header: Text("Other")) {
                Statistic(name: "Total Guesses", detail: "\(Progress.totalGuesses)", symbolName: "lightbulb")
            }
        }
        .navigationBarTitle(playMode.name)
    }
}

struct StatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsView()
    }
}

struct Statistic: View {
    
    var name: String
    var detail: String
    var symbolName: String
    
    var body: some View {
        HStack {
            Text(name)
            Spacer()
            Text(detail)
                .foregroundColor(.secondary)
        }
        .icon(symbolName)
    }
}
