
import SwiftUI

// A view showing the answers to yesterday's daily puzzle

struct YesterdaysAnswersView: View {
    
    @Environment(\.presentationMode)  var presentationMode
    @EnvironmentObject var gameModel: GameModel
    
    // Yesterday's puzzle
    var puzzle: Puzzle {
        if let seed = gameModel.puzzle.seed {
            return DomingoEngine.newPuzzleForSeed(seed - 1)
        }
        else {
            return DomingoEngine.newRandomPuzzle()
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                
                VStack {
                    ForEach(puzzle.questions) { question in
                        HStack {
                            (Text(question.left.capitalized)
                            + Text(question.formattedInsert)
                                .font(.body.weight(.bold))
                                .foregroundColor(.accentColor)
                            + Text(question.right))
                            .speechSpellsOutCharacters()

                            Spacer()
                            
                            Text(question.clue)
                                .foregroundColor(.secondary)
                                .speechSpellsOutCharacters()
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal)
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .foregroundColor(Color(UIColor.secondarySystemGroupedBackground))
                )
                .padding(.vertical)
                
                PuzzleViewCaption(puzzle: puzzle, pastPuzzle: true)
                    .foregroundColor(.secondary)
                
                Spacer()
            }
            .padding()
            .background(Color(UIColor.systemGroupedBackground).edgesIgnoringSafeArea(.all))
            .navigationTitle("Yesterday's Answers")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {presentationMode.wrappedValue.dismiss()}
                }
            }
        }
    }
}
