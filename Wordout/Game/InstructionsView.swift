
import SwiftUI

// A view displaying information on how to play the game

struct InstructionsView: View {
    
    @Environment(\.presentationMode)  var presentationMode
    
    private let exampleQuestions = [
        Question(container: "unorthodox", insert: "north"),
        Question(container: "breastplate", insert: "east"),
        Question(container: "narrowest", insert: "west")
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 40) {
                    
                    Text("\(DomingoEngine.appName.capitalized) is a game about words within words. To solve a puzzle, replace each of the codas (\(DomingoEngine.placeholder)) with a word to form a new, longer word.")
                    VStack {
                        InstructionsExamplesView(questions: exampleQuestions)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 14)
                                .foregroundColor(Color(UIColor.secondarySystemGroupedBackground)))
                    }
                    
                    Text("To make things easier, each puzzle has a category. The words you use to replace the stars will all be related to this theme. In the example above, the category is compass points.")
                    
                    InstructionsSectionView(title: "Yesterday's Answers", text: "If you don't manage to solve a daily puzzle in time, don't panic! You can always check yesterday's answers from the menu at the top right hand of the puzzle screen.")
                    
                    InstructionsSectionView(title: "Forgotten the Rules?", text: "Don't panic– you can always find them again in the same menu at the top right corner of each puzzle.")
                    
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top)
            }
            .background(Color(UIColor.systemGroupedBackground).edgesIgnoringSafeArea(.all))
            .navigationTitle("How to Play")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {presentationMode.wrappedValue.dismiss()}
                }
            }
        }
    }
}

struct InstructionsView_Previews: PreviewProvider {
    static var previews: some View {
        InstructionsView()
    }
}


struct InstructionsExamplesView: View {
    
    var questions: [Question]
    
    var body: some View {
        ForEach(questions) { question in
            HStack {
                Spacer()
                Text(question.clue)
                    .frame(width: 100)
                    .speechSpellsOutCharacters()
                Text("  ↔︎  ").foregroundColor(.accentColor)
                    .accessibilityLabel("corresponds to")
                (Text(question.left.capitalized)
                + Text(question.formattedInsert)
                    .fontWeight(.bold)
                + Text(question.right)).frame(width: 100)
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel(question.container)
                Spacer()
            }
        }
    }
}

struct InstructionsSectionView: View {
    
    var title: String
    var text: String
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.headline)
            
            Text(text)
        }
    }
}
