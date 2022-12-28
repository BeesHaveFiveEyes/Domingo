//
//  StatisticsView.swift
//  Wordout
//
//  Created by Alasdair Casperd on 12/11/2022.
//

import SwiftUI

struct StatisticsView: View {
    
    private let playMode = PlayMode.statistics
    
    var body: some View {
        Form {
            Section(header: Text("Daily Puzzles")) {
                Statistic(name: "Daily Puzzles Completed", detail: "\(Statistics.dailyPuzzlesCompleted.value)", symbolName: "calendar")
                Statistic(name: "Success Rate", detail: Statistics.successRate == nil ? "N/A" : "\(Statistics.successRate!)%", symbolName: "scope")
                Statistic(name: "Current Streak", detail: "\(Statistics.streak.value)", symbolName: "flame")
                Statistic(name: "Longest Streak", detail: "\(Statistics.longestStreak.value)", symbolName: "medal")
            }
            
            Section(header: Text("Categories")) {
                Statistic(name: "Categories Completed", detail: "\(Statistics.categoriesCompleted) / \(Statistics.totalCategories)", symbolName: "books.vertical")
                Statistic(name: "Overall Completion", detail: "\(Statistics.questionCompletionPercentage)%", symbolName: "checkmark.circle")
            }
            
            Section(header: Text("Other")) {
                Statistic(name: "Total Guesses", detail: "\(Statistics.guesses.value)", symbolName: "lightbulb")
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
