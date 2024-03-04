
import SwiftUI

// The overarching view for all sheet-based puzzle modes
// (i.e. for daily, archived and random puzzles)

struct GameView: View {
    
    @StateObject var gameModel: GameModel
    @Namespace var namespace
    
    var body: some View {
        Group {
            switch gameModel.gameState {
            case .welcome:
                WelcomeView(namespace: namespace)
            case .inProgress:
                PuzzleView(namespace: namespace)
            case .complete:
                CompleteView(namespace: namespace)
            }
        }
        .accentColor(DomingoEngine.themeColor)
        .environmentObject(gameModel)
    }
}
