
import SwiftUI

// A view welcoming the user to a particular puzzle
// If launching archive mode, this view also shows a date picker

struct WelcomeView: View {
    
    @EnvironmentObject var gameModel: GameModel
    
    var namespace: Namespace.ID
    
    @State var chosenDate: Date = Date().addingTimeInterval(-1 * 24 * 60 * 60)
    
    var body: some View {
        
        VStack(alignment: .center) {
            
            Spacer()
            
            Image(systemName: gameModel.gameModeSymbolName)
                .foregroundColor(.white)
                .font(.system(size: 60))
                .padding(.bottom, 1)
                        
            
            Text(gameModel.gameModeName)
                .font(.largeTitle.weight(.bold))
                .foregroundColor(.white)
                .matchedGeometryEffect(id: "title", in: namespace)
            
            Text(gameModel.welcomeViewCaption)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .padding(.horizontal, 20)
            
            // Date Picker
            
            if gameModel.showDatePicker {
                DatePicker("Puzzle date", selection: $chosenDate, in: (Date.referenceDate...Date()), displayedComponents: [.date])
                    .padding()
                    .datePickerStyle(.compact)
                    .colorScheme(.dark)
                    .background(RoundedRectangle(cornerRadius: 14).foregroundColor(.black).opacity(0.1))
                    .padding()
            }
            
            // Primary button
            
            PanelButton(text: gameModel.welcomeViewPrimaryButtonText, action: transition, primary: true)
                .transition(.asymmetric(insertion: .opacity, removal: .scale))
                .padding(.top, 40)
            
            // Secondary button
            
            PanelButton(text: gameModel.welcomeViewSecondaryButtonText, action: gameModel.quit, primary: false)
                .transition(.asymmetric(insertion: .opacity, removal: .scale))
                .padding(.top, 8)
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.accentColor)
    }
    
    private func transition() {
        if gameModel.showDatePicker {
            gameModel.transitionTo(.inProgress, inputDate: chosenDate)
        }
        else {
            gameModel.transitionTo(.inProgress)
        }
    }
}

#Preview {
    WelcomeView(namespace: Namespace().wrappedValue)
        .environmentObject(GameModel(gameMode: .dailyPuzzle, quit: {}))
}
