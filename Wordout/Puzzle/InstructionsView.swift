//
//  InstructionsView.swift
//  Wordout
//
//  Created by Alasdair Casperd on 07/11/2022.
//

import SwiftUI

struct InstructionsView: View {
    
    @Environment(\.presentationMode)  var presentationMode
    
    private let exampleQuestions = [
        Question(id: 0, container: "unorthodox", insert: "north"),
        Question(id: 1, container: "breastplate", insert: "east"),
        Question(id: 2, container: "narrowest", insert: "west")
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 40) {
                    
                    Text("Each clue in a \(WordoutApp.appName) puzzle consists of a word in which some letters have been obscurred by a star. To solve the puzzle, replace each star with a word from the puzzle's category to recover the original word.")
                    VStack {
                        InstructionsExamplesView(questions: exampleQuestions)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 14)
                                .foregroundColor(Color(UIColor.secondarySystemGroupedBackground)))
                    }
                    
                    Text("In the example above, the category is ") + Text("compass points").font(.body.italic()) + Text(".")
                    
                    
//                    VStack(alignment: .leading, spacing: 15) {
//                        Text("Stuck?")
//                            .font(.title3.weight(.bold))
//                        Text("Hint")
//                    }
                    
//                    Button(action: { presentationMode.wrappedValue.dismiss() }) {
//                        HStack {
//                            Spacer()
//                            Text("Done")
//                                .padding()
//                            Spacer()
//                        }
//                    }
//                    .background(
//                        RoundedRectangle(cornerRadius: 14)
//                            .foregroundColor(Color(UIColor.secondarySystemGroupedBackground)))
//                    
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
                Text("  ↔︎  ").foregroundColor(.accentColor)
                (Text(question.left.capitalized)
                + Text(question.formattedInsert)
                    .fontWeight(.bold)
                + Text(question.right)).frame(width: 100)
                Spacer()
            }
        }
    }
}
