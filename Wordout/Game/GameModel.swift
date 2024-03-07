
import SwiftUI

// Model handling the 'game screens' including the daily puzzle, archived mode and random mode

class GameModel: ObservableObject {
    
    // ------------
    // Enumerations
    // ------------
    
    enum GameState {
        case welcome
        case inProgress
        case complete
    }
    
    enum GameMode {
        case dailyPuzzle
        case archivedPuzzle
        case randomPuzzle
    }
    
    // -----------------
    // Stored Properties
    // -----------------
    
    // The current game mode (daily puzzle / archive / random)
    let gameMode: GameMode
    
    // The current state of the game (welcome screen / inProgress / completed)
    @Published var gameState: GameState
    
    // The puzzle associated with this game
    @Published var puzzle: Puzzle
    
    // Puzzle input field text
    @Published var inputFieldText = ""
    
    // Puzzle input field focus state
    @Published var inputFieldFocused = false
    
    // View presentation bools
    @Published var showingResetAlert = false
    @Published var showingInstructions = false
    @Published var showingYesterdaysAnswers = false
    
    // Closure to quit to the main menu
    @Published var quit: () -> ()
    
    // ---------
    // Functions
    // ---------
    
    // Show the 'how to play' screen
    func showInstructions() {
        if (gameState == .inProgress) {
            showingInstructions = true
            Statistics.userHasSeenInstructions.replace(with: true)
        }
    }
    
    // Show yesterday's answers
    func showYesterdaysAnswers() {
        if (gameState == .inProgress) {
            showingYesterdaysAnswers = true
        }
    }
    
    // Show the confirmation dialogue to reset the puzzle
    func showResetAlert() {
        if (gameState == .inProgress) {
            showingResetAlert = true
        }
    }
    
    // Transition to a particular game state, recording an input date if needed
    func transitionTo(_ gameState: GameState, inputDate: Date? = nil) {
        if gameMode == .dailyPuzzle {
            if gameState == .inProgress { Statistics.logDailyAttempt() }
        }
        else if gameMode == .randomPuzzle {
            puzzle = DomingoEngine.newRandomPuzzle()
        }
        else if let date = inputDate {
            puzzle = DomingoEngine.newPuzzleForDate(date)
        }
        withAnimation {
            self.gameState = gameState
        }
    }
    
    // Copy a textual description of the puzzle to the clipboard
    func copyPuzzleAsText() {
        puzzle.copyAsText()
    }
    
    // When an question view is tapped, focus the text field if the question hasn't been guessed
    func handleQuestionTap(_ question: Question) {
        if !(puzzle.progress[question] ?? false) {
            inputFieldFocused = true
        }
    }
    
    // Submit a guess to the puzzle
    func handleGuess() {
        if puzzle.handleGuess(inputFieldText) {
            inputFieldText = ""
            playSuccessHaptic()
        }
        else {
            playErrorHaptic()
        }
        
        if puzzle.completed {
            transitionTo(.complete)
            if (gameMode == .dailyPuzzle)
            {
                Statistics.logDailyPuzzleCompletion()
            }
            else if (gameMode == .archivedPuzzle)
            {
                Statistics.logArchivedPuzzleCompletion()
            }
        }
        
        if (gameMode == .dailyPuzzle) {
            DomingoEngine.storeDailyPuzzle(puzzle)
        }
    }
    
    // Reset the progress on the current puzzle
    func resetPuzzle() {
        puzzle.reset()
        if (gameMode == .dailyPuzzle) {
            DomingoEngine.storeDailyPuzzle(puzzle)
        }
    }
    
    // -------------------
    // Computed Properties
    // -------------------
    
    // The name of the current game mode
    var gameModeName: String {
        switch gameMode {
        case .dailyPuzzle:
            "Daily Puzzle"
        case .archivedPuzzle:
            "Archived Puzzle"
        case .randomPuzzle:
            "Random Puzzle"
        }
    }
    
    // The name of the SF symbol to represent the current game mode
    var gameModeSymbolName: String {
        switch gameMode {
        case .dailyPuzzle:
            return "calendar"
        case .archivedPuzzle:
            return "archivebox.fill"
        case .randomPuzzle:
            return "dice.fill"
        }
    }
    
    // The caption for the welcome view
    var welcomeViewCaption: String {
        switch gameMode {
        case .dailyPuzzle:
            if puzzle.completed {
                return "You've already completed today's puzzle."
            }
            else if Settings.streaksEnabled && Statistics.currentStreak.value > 0 {
                if puzzle.totalQuestionsGuessed > 0 {
                    return "Don't lose your \(Statistics.currentStreak.value) day streak!"
                }
                else {
                    return "Continue your \(Statistics.currentStreak.value) day streak!"
                }
            }
            else if puzzle.totalQuestionsGuessed > 0 {
                return "Will you solve today's puzzle?"
            }
            else {
                return "Ready for your daily puzzle?"
            }
        case .archivedPuzzle:
            return "Choose a date below to replay the any past daily puzzle of your choice."
        case .randomPuzzle:
            return "Randomly generate as many puzzles as your heart desires!"
        }
    }
    
    // The primary button text for the welcome view
    var welcomeViewPrimaryButtonText: String {
        
        switch gameMode {
        case .dailyPuzzle:
            if puzzle.completed {
                return "Review"
            }
            else if puzzle.totalQuestionsGuessed > 0 {
                return "Resume"
            }
            else {
                return "Play"
            }
        case .archivedPuzzle:
            return "Select"
        case .randomPuzzle:
            return "Generate"
        }
    }
    
    // The secondary button text for the welcome view
    var welcomeViewSecondaryButtonText: String {
        return "Quit"
    }
    
    // Text to be added to the puzzle name in the complete view
    // This is separate to facilitate a matched geometry effect transition
    var completeViewTitleExtension: String {
        return "Complete!"
    }
    
    // The caption of the complete view
    var completeViewCaption: String {
        switch gameMode {
        case .dailyPuzzle:
            return "Congratulations! You've completed today's daily puzzle. Check back tomorrow for a new one!"
        case .archivedPuzzle, .randomPuzzle:
            return "Congratulations! You've completed this puzzle."
        }
    }
    
    // The primary button text for the complete view
    var completeViewPrimaryButtonText: String {
        return "Done"
    }
    
    // Should the welcome view display a date picker?
    var showDatePicker: Bool {
        return gameMode == .archivedPuzzle
    }
    
    // An array of menu actions accessible from the toolbar in puzzle view
    var menuActions: [MenuAction] {
        
        var output = [MenuAction]()
        
        // How to Play
        output.append(MenuAction(description: "How to Play", symbolName: "questionmark.circle", action: showInstructions))
        
        // Yesterday's Answers
        if gameMode == .dailyPuzzle {
            
            output.append(MenuAction(description: "Yesterday's Answers", symbolName: "clock.badge.checkmark", action: showYesterdaysAnswers))
            
            output.append(MenuAction(description: "Copy Puzzle", symbolName: "doc.on.doc", action: copyPuzzleAsText))
        }
        
        // Reset progress
        if puzzle.totalQuestionsGuessed > 0 {
            output.append(MenuAction(description: "Reset Progress", symbolName: "arrow.counterclockwise", action: showResetAlert))
        }
        
        return output
    }
    
    // ------------
    // Initialisers
    // ------------
    
    init(gameMode: GameMode, quit: @escaping () -> ()) {
        self.gameMode = gameMode
        self.gameState = .welcome
                
        switch gameMode {
        case .dailyPuzzle:
            puzzle = DomingoEngine.loadTodaysPuzzle()
        case .archivedPuzzle:
            puzzle = DomingoEngine.newPuzzleForDate(Date())
        case .randomPuzzle:
            puzzle = DomingoEngine.newRandomPuzzle()
        }
                
        self.quit = quit
    }
}
