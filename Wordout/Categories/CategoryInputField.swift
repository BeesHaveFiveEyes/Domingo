
import SwiftUI

// The input field for the categories view

struct CategoryInputField: View {
    
    @EnvironmentObject var model: CategoryViewModel
    @FocusState var inputFieldFocused
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
                Divider()
                HStack {
                    TextField("Enter a guess...", text: $model.inputFieldText)
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
                        .onSubmit(model.handleGuess)
                        .onChange(of: inputFieldFocused) { model.inputFieldFocused = $0 }
                        .onChange(of: model.inputFieldFocused) { inputFieldFocused = $0 }
                        .onAppear { inputFieldFocused = model.inputFieldFocused }
                }
                .background(Color(UIColor.secondarySystemGroupedBackground))

        }
    }
}
