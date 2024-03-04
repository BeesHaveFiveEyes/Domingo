
import SwiftUI
import UniformTypeIdentifiers

// A collection of questions making up a puzzle and the users progress in solving them

class Puzzle {
    
    // -----------------
    // Stored Properties
    // -----------------
    
    // A unique ID for the puzzle
    let id: UUID = UUID()
    
    // The category from which the puzzle draws its questions
    var category: Category
    
    // The array of questions in the puzzle
    var questions: [Question]
    
    // A dictionary showing which questions have been guessed
    var progress: [Question: Bool]
    
    // The seed used to create the puzzle, if one was used
    var seed: Int?
    
    // -------------------
    // Computed Properties
    // -------------------
    
    // The number of question in this puzzle that have been correctly guessed
    var totalQuestionsGuessed: Int {
        return progress.filter({ $0.value }).count
    }
    
    // Has this puzzle been completed?
    var completed: Bool {
        return totalQuestionsGuessed == questions.count
    }
    
    // A textual description of the puzzle
    var textDescription: String {
        var output = "Domingo Puzzle\n"
        output += Date().formatted(.dateTime.day().month(.wide).year())
        output += "\n"
        for question in questions {
            output += "\n"
            output += question.clue
        }
        output += "\n\nThe category is \(category.name.capitalized)"
        return output
    }
    
    // ---------
    // Functions
    // ---------
    
    // Check if a guess matches any of the questions in the puzzle
    // Mark any correctly guessed questions as complete and return true iff
    
    func handleGuess(_ guess: String) -> Bool {
        var output = false
        for q in questions {
            // Check if the guess matches either the insert word of the container word
            if guess.uppercased() == q.insert.uppercased() || guess.uppercased() == q.container.uppercased() {
                // Mark this question as guessed
                progress[q] = true
                output = true
            }
        }
        return output
    }
    
    // Reset all the progress through the puzzle
    
    func reset() {
        for question in questions {
            progress[question] = false
        }
    }
    
    // Copy a textual description of the puzzle
    
    func copyAsText() {
        UIPasteboard.general.setValue(textDescription, forPasteboardType: UTType.plainText.identifier)
    }
    
    // ------------
    // Initialisers
    // ------------
    
    init(category: Category, questions: [Question], seed: Int? = nil) {
        
        self.category = category
        self.questions = questions
        self.seed = seed
        
        var progress = [Question: Bool]()
        for q in questions {
            progress[q] = false
        }
        self.progress = progress
    }
}
