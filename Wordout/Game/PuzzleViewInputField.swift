
import SwiftUI

// The input field for the puzzle view

struct PuzzleViewInputField: View {
    
    @EnvironmentObject var gameModel: GameModel
    @FocusState var inputFieldFocused
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
                Divider()
                HStack {
                    TextField("Enter a guess...", text: $gameModel.inputFieldText)
                        .padding(.horizontal)
                        .padding(.vertical, 7)
                        .background(
                            RoundedRectangle(cornerRadius: 9)
                                .foregroundColor(Color(UIColor.systemGroupedBackground))
                        )
                        .keyboardType(.alphabet)
                        .autocorrectionDisabled(true)
                        .padding()
                        .focused($inputFieldFocused)
                        .onSubmit(gameModel.handleGuess)
                        .onChange(of: inputFieldFocused) { gameModel.inputFieldFocused = $0 }
                        .onChange(of: gameModel.inputFieldFocused) { inputFieldFocused = $0 }
                        .onAppear { inputFieldFocused = gameModel.inputFieldFocused }
                }
                .background(Color(UIColor.secondarySystemGroupedBackground))

        }
    }
}
