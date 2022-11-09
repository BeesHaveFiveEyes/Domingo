//
//  YesterdayAnswersView.swift
//  Wordout
//
//  Created by Alasdair Casperd on 07/11/2022.
//

import SwiftUI

struct YesterdayAnswersView: View {
    
    @Environment(\.presentationMode)  var presentationMode
    
    private var puzzle: Puzzle {
        return Puzzle.puzzleForDate(Date().addingTimeInterval(-24*60*60))
    }
    
    var body: some View {
        NavigationView {
            VStack {
                
                VStack {
                    ForEach(puzzle.questions) { question in
                        HStack {
                            Text(question.left.capitalized)
                            + Text(question.left == "" ? "" : "-")
                            + Text(question.formattedInsert).font(.body.weight(.bold))
                            + Text(question.right == "" ? "" : "-")
                            + Text(question.right)
                            Spacer()
                            Text(question.clue)
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .foregroundColor(Color(UIColor.secondarySystemGroupedBackground))
                )
                .padding(.vertical)
                
                (Text("The theme was \(puzzle.emoji) ") + Text(puzzle.name))
                    .foregroundColor(.secondary)
                    .padding()
                
                Spacer()
            }
            .padding()
            .background(Color(UIColor.systemGroupedBackground).edgesIgnoringSafeArea(.all))
            .navigationTitle("Yesterday's Answers")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {presentationMode.wrappedValue.dismiss()}
                }
            }
        }
    }
}

struct YesterdayAnswersView_Previews: PreviewProvider {
    static var previews: some View {
        YesterdayAnswersView()
    }
}
