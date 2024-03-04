
import SwiftUI

// A view displaying all of the user's puzzle statistics

struct StatisticsView: View {
    
    var body: some View {
        Form {
            
            Section(header: Text("Domingo Streak")) {
                StatisticRowView(name: "Current Streak", detail: "\(Statistics.currentStreak.value)", symbolName: "flame")
                StatisticRowView(name: "Longest Streak", detail: "\(Statistics.longestStreak.value)", symbolName: "medal")
            }
            
            Section(header: Text("Daily Puzzles")) {
                StatisticRowView(name: "Daily Puzzles Completed", detail: "\(Statistics.dailyPuzzlesCompleted.value)", symbolName: "calendar")
                StatisticRowView(name: "Success Rate", detail: Statistics.successRate == nil ? "N/A" : "\(Statistics.successRate!)%", symbolName: "scope")
            }
            
            Section(header: Text("Categories")) {
                StatisticRowView(name: "Categories Completed", detail: "\(Statistics.totalCategoriesCompleted) / \(Statistics.totalCategories)", symbolName: "books.vertical")
                StatisticRowView(name: "Overall Completion", detail: "\(Statistics.categoryQuestionCompletionPercentage)%", symbolName: "checkmark.circle")
            }
            
            Section(header: Text("Other")) {
                StatisticRowView(name: "Archived Puzzles Completed", detail: "\(Statistics.archivedPuzzlesCompleted.value)", symbolName: "archivebox")
                StatisticRowView(name: "Total Guesses", detail: "\(Statistics.guesses.value)", symbolName: "lightbulb")
            }
        }
        .navigationBarTitle("Statistics")
    }
}

struct StatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsView()
    }
}
