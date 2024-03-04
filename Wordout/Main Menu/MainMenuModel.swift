
import Foundation

// Model handling the main menu and the presentaiton of any views leading off from it

class MainMenuModel: ObservableObject {
    
    // View presentation bools
    @Published var showingDailyView: Bool = false
    @Published var showingCategoriesView: Bool = false
    @Published var showingArchiveView: Bool = false
    @Published var showingRandomView: Bool = false
    @Published var showingStatisticsView: Bool = false
    @Published var showingSettingsView: Bool = false
    @Published var showingDebugView: Bool = false
    @Published var showingInAppPurchaseView: Bool = false
    
    // A function called when the user returns to the app
    func onReturnToApp() {
        onReturnToMenu()
    }
    
    // A function called when the user returns to the main menu
    func onReturnToMenu() {        
        Statistics.checkForMissedStreak()
    }
    
    // Hide all presented views and return to the main menu
    private func hideAllViews() {
        showingDailyView = false
        showingCategoriesView = false
        showingArchiveView = false
        showingRandomView = false
        showingStatisticsView = false
        showingSettingsView = false
        showingDebugView = false
        showingInAppPurchaseView = false
    }
    
    // Return to the main menu
    func returnToMenu() {
        hideAllViews()
        onReturnToMenu()
    }
    
    // Show the daily puzzle player
    func showDailyView() {
        hideAllViews()
        showingDailyView = true
    }
    
    // Show the categories view
    func showCategoriesView() {
        hideAllViews()
        showingCategoriesView = true
    }
    
    // Show the archived puzzle player
    func showArchiveView() {
        hideAllViews()
        showingArchiveView = true
    }
    
    // Show the random puzzle player
    func showRandomView() {
        hideAllViews()
        showingRandomView = true
    }
    
    // Show the purchase view
    func showInAppPurchaseView() {
        showingInAppPurchaseView = true
    }
    
    // Show the debug screen
    func showDebugView() {
        hideAllViews()
        showingDebugView = true
    }
    
    // A delay used specifically for the main menu animation
    let animationDelay = 1.0
    
    // The subtitle to display on the 'daily puzzle' menu item
    var dailyPuzzleSubtitle: String {
        let todaysPuzzle = DomingoEngine.loadTodaysPuzzle()
        
        if Settings.streaksEnabled && Statistics.currentStreak.value > 0 {
            if todaysPuzzle.completed {
                return "\(Statistics.currentStreak.value) Day Streak"
            }
            else if todaysPuzzle.totalQuestionsGuessed > 0 {
                return "\(todaysPuzzle.totalQuestionsGuessed) / \(DomingoEngine.dailyPuzzleLength) Complete"
            }
            else {
                return "Continue your \(Statistics.currentStreak.value) day streak"
            }
        }
        else {
            if todaysPuzzle.completed {
                return "Completed for Today"
            }
            else if todaysPuzzle.totalQuestionsGuessed > 0 {
                return "\(todaysPuzzle.totalQuestionsGuessed) / \(DomingoEngine.dailyPuzzleLength) Complete"
            }
            else {
                return Date().formatted(.dateTime.day().month(.wide))
            }
        }
    }
}
