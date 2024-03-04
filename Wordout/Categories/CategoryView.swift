
import SwiftUI

// A view displaying all the questions in a particular category

struct CategoryView: View {

    @EnvironmentObject var model: CategoryViewModel
    @Environment(\.presentationMode) var presentationMode
    
    func quit() {
        presentationMode.wrappedValue.dismiss()
    }
    
    var body: some View {
        ScrollView {    
            
            // Progress View
            
            ProgressView("\(model.puzzle.totalQuestionsGuessed) / \(model.puzzle.questions.count) Complete", value: Double(model.puzzle.totalQuestionsGuessed), total: Double(model.puzzle.questions.count))
            .foregroundColor(.secondary)
            .padding()
            
            // List of Questions
            
            ForEach(model.category.questions) { question in
                Button(action: {model.handleQuestionTap(question)}) {
                    QuestionView(question: question, guessed: model.puzzle.progress[question] ?? false)
                }
            }
        }
        .background(DomingoEngine.backgroundColor)
        .overlay {
            
            // Input Field
            
            if !model.puzzle.completed && (model.inputFieldFocused || model.inputFieldText != "") {
                CategoryInputField()
            }
        }
        .sheet(isPresented: $model.showingInstructions) {
            InstructionsView()
                .accentColor(DomingoEngine.themeColor)
        }
        .alert("Reset this puzzle?", isPresented: $model.showingResetAlert) {
            Button("Reset", role: .destructive, action: model.resetPuzzle)
        } message: {
            Text("Other puzzles will not be affected.")
        }
        .navigationTitle(model.category.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem {
                Menu {
                    ForEach(model.menuActions) { menuAction in
                        Button(action: menuAction.action) {
                            Label(menuAction.description, systemImage: menuAction.symbolName)
                        }
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
        .onAppear {
            if !Statistics.userHasSeenInstructions.value {
                model.showInstructions()
            }
        }
    }
}

struct CategoryView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CategoryView()
                .environmentObject(CategoryViewModel(category: .categories[0]))
        }
    }
}
