
import SwiftUI

// A view displaying a question from a puzzle or category

struct QuestionView: View {
            
    // The displayed question
    var question: Question
    
    // Has the question been guessed?
    var guessed: Bool
    
    // Color overrides
    var textColor: Color = .primary
    var placeholderColor: Color = .accentColor
    var backgroundColor: Color = Color(UIColor.secondarySystemGroupedBackground)
    var backgroundOpacity = 1.0
    
    // The text to display within the container word
    var placeholder: String {
        if guessed {
            return question.formattedInsert
        }
        else {
            return " " + DomingoEngine.placeholder + " "
        }
    }
    
    var body: some View {
        HStack(alignment: .center) {
            
            Image(systemName: "checkmark.circle")
                .frame(width: 8, alignment: .trailing)
                .opacity(0)
                .padding()
            
            Spacer()
            
            (Text(question.left.capitalized)
                .foregroundColor(textColor)
                .speechSpellsOutCharacters()
            + Text(placeholder)
                .foregroundColor(guessed ? .secondary : placeholderColor)
                .accessibilityLabel("Space")
            + Text(question.right)
                .foregroundColor(textColor))
                .padding()
                .speechSpellsOutCharacters()
            
            Spacer()
            
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.green)
                .opacity(guessed ? 1 : 0)
                .frame(width: 8, alignment: .trailing)
                .padding()
        }
        .opacity(guessed ? 0.5 : 1)
        .background(RoundedRectangle(cornerRadius: 14).foregroundColor(backgroundColor).opacity(backgroundOpacity))
        .padding(.horizontal)
    }
}
