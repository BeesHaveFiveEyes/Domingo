//
//  QuestionView.swift
//  Wordout
//
//  Created by Alasdair Casperd on 04/11/2022.
//

import SwiftUI

struct QuestionView: View {
    
    var category: Category?
    var question: Question
    var guessed: Bool
    
    var textColor: Color = .primary
    var placeholderColor: Color = .accentColor
    var backgroundColor: Color = Color(UIColor.secondarySystemGroupedBackground)
    var backgroundOpacity = 1.0
    
    var placeholder: String {
        if question.guessed {
            return question.formattedInsert
        }
        else {
            return " " + Domingo.placeholder + " "
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
            + Text(placeholder)
                .foregroundColor(guessed ? .secondary : placeholderColor)
            + Text(question.right)
                .foregroundColor(textColor))
                .padding()
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

struct QuestionView_Previews: PreviewProvider {
    static var previews: some View {
        Form {
            QuestionView(question: Category.example.questions[0], guessed: false)
            QuestionView(question: Category.example.questions[0], guessed: true)
        }
    }
}
