
import SwiftUI

// The model behind CategoryView

class CategoryViewModel: ObservableObject {
    
    // -----------------
    // Stored Properties
    // -----------------
    
    // The category to be displayed
    let category: Category
    
    // A puzzle corresponding to all of the questions in this category
    let puzzle: Puzzle
    
    // Category input field text
    @Published var inputFieldText = ""
    
    // Category input field focus state
    @Published var inputFieldFocused = false
    
    // View presentation bools
    @Published var showingResetAlert = false
    @Published var showingInstructions = false
    
    // ---------
    // Functions
    // ---------
    
    // Show the 'how to play' screen
    func showInstructions() {
        showingInstructions = true
        Statistics.userHasSeenInstructions.replace(with: true)
    }
    
    // Show the confirmation dialogue to reset the puzzle
    func showResetAlert() {
        showingResetAlert = true
    }
    
    // Submit a guess to the questions of the category
    func handleGuess() {
        if puzzle.handleGuess(inputFieldText) {
            inputFieldText = ""
            playSuccessHaptic()
        }
        else {
            playErrorHaptic()
        }
        
        DomingoEngine.storeCategoryPuzzle(puzzle)
    }
    
    // Reset the user's progress in this category
    func resetPuzzle() {
        puzzle.reset()
        DomingoEngine.storeCategoryPuzzle(puzzle)
    }
    
    // When an question view is tapped, focus the text field if the question hasn't been guessed
    func handleQuestionTap(_ question: Question) {
        if !(puzzle.progress[question] ?? false) {
            inputFieldFocused = true
        }
    }
    
    // -------------------
    // Computed Properties
    // -------------------
    
    // The items to display in the navigation bar menu
    var menuActions: [MenuAction] {
        
        var output = [MenuAction]()
        
        // How to Play
        output.append(MenuAction(description: "How to Play", symbolName: "questionmark.circle", action: showInstructions))
        
        // Reset progress
        if puzzle.totalQuestionsGuessed > 0 {
            output.append(MenuAction(description: "Reset Progress", symbolName: "arrow.counterclockwise", action: showResetAlert))
        }
        
        return output
    }
    
    // ------------
    // Initialisers
    // ------------
    
    init(category: Category) {
        self.category = category
        self.puzzle = DomingoEngine.loadCategoryPuzzle(category)
    }
}
