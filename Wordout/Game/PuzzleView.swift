
import SwiftUI

// View displaying one of the game's puzzles
// Used in daily, archive and random mode

struct PuzzleView: View {
    
    @EnvironmentObject var gameModel: GameModel
    var namespace: Namespace.ID
    
    var body: some View {
        VStack {
            
            // Header
            PuzzleViewTopBar(namespace: namespace)
            
            // List of questions
            // (The 'i'-based ForEach is necessary to handle the animation offsets)
            ForEach(0..<gameModel.puzzle.questions.count, id: \.self) { i in
                Button(action: {gameModel.handleQuestionTap(gameModel.puzzle.questions[i])}) {
                    QuestionView(question: gameModel.puzzle.questions[i], guessed: gameModel.puzzle.progress[gameModel.puzzle.questions[i]] ?? false)
                        .scaleInAfter(offset: i)
                }
            }
            
            // Caption
            PuzzleViewCaption(puzzle: gameModel.puzzle)
            .fadeInAfter(offset: DomingoEngine.dailyPuzzleLength)
            
            Spacer()
        }
        .background(Color(UIColor.systemGroupedBackground)
        .edgesIgnoringSafeArea(.all))
        .navigationBarHidden(true)
        .overlay {
            PuzzleViewInputField()
        }                
        .sheet(isPresented: $gameModel.showingInstructions) {
            InstructionsView()
                .accentColor(DomingoEngine.themeColor)
        }
        .sheet(isPresented: $gameModel.showingYesterdaysAnswers) {
            YesterdaysAnswersView()
                .accentColor(DomingoEngine.themeColor)
        }
        .alert("Reset this puzzle?", isPresented: $gameModel.showingResetAlert) {
            Button("Reset", role: .destructive, action: gameModel.resetPuzzle)
        } message: {
            Text("Other puzzles will not be affected.")
        }
        .onAppear {
            if !Statistics.userHasSeenInstructions.value {
                gameModel.showInstructions()
            }
        }
    }
}
