
import SwiftUI

// A view showing a caption underneath one of the game's puzzle
// This states the puzzle's theme unless hardmode is enabled

struct PuzzleViewCaption: View {
    
    var puzzle: Puzzle
    var pastPuzzle = false
    
    var body: some View {
        Group {
            if !pastPuzzle && Settings.hardModeEnabled {
                Text("The category is hidden in Hard Mode")
            }
            else {
                Text("The category \((puzzle.completed || pastPuzzle) ? "was" : "is") ")
                + Text(Image(systemName: puzzle.category.symbolName))
                + Text(" \(puzzle.category.name)")
            }
        }
        .foregroundColor(.secondary)
        .padding()
    }
}
