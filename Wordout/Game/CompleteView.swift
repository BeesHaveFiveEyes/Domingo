
import SwiftUI

// A congratulatory view displayed when a puzzle has been completed

struct CompleteView: View {
        
    @EnvironmentObject var gameModel: GameModel
    
    var namespace: Namespace.ID
    
    var body: some View {

        VStack(alignment: .center) {
            
            Spacer()
            
            // Title
            
            VStack {
                Text(gameModel.gameModeName)
                    .matchedGeometryEffect(id: "title", in: namespace)
                Text(gameModel.completeViewTitleExtension)
            }
            .font(.largeTitle.weight(.bold))
            .padding(.bottom)
            
            
            // Streak Details
            
            if gameModel.gameMode == .dailyPuzzle && Statistics.currentStreak.value > 1 {
                HStack {
                    Image(systemName: "flame.fill")
                    Text("\(Statistics.currentStreak.value) Day Streak")
                }
                .font(.body.weight(.bold))
                .padding(8)
                .background {
                    Capsule()
                        .foregroundColor(.black)
                        .opacity(0.1)
                }
                .padding(.bottom)
            }
            
            // Caption
            
            HStack {
                Text(gameModel.completeViewCaption)
            }
            .multilineTextAlignment(.center)
            .padding(.horizontal)
            
            // Answers
            
            // TODO: Remove duplication of code
            
            VStack {
                ForEach(gameModel.puzzle.questions) { question in
                    HStack {
                        (Text(question.left.capitalized)
                        + Text(question.left == "" ? "" : "")
                        + Text(question.formattedInsert).font(.body.weight(.bold))
                        + Text(question.right == "" ? "" : "")
                        + Text(question.right))
                        .speechSpellsOutCharacters()
                        Spacer()
                        Image(systemName: "checkmark.circle")
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal)
                }
            }
            .padding(.vertical)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .foregroundColor(.black)
                    .opacity(0.1)
            )
            .padding()
            
            PanelButton(text: gameModel.completeViewPrimaryButtonText, action: gameModel.quit, primary: true)
                .padding(.top, 30)
            
            Spacer()
        }
        .foregroundColor(.white)
        .padding()
        .background(Color.accentColor)
    }
}
