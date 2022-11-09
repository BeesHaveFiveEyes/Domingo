//
//  CompleteView.swift
//  Wordout
//
//  Created by Alasdair Casperd on 03/11/2022.
//

import SwiftUI

struct CompleteView: View {
    
    var primaryButtonAction: () -> ()
    var puzzle: Puzzle
    
    var playMode: PlayMode
    
    var namespace: Namespace.ID
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                VStack {
                    Text(playMode.name)
                        .matchedGeometryEffect(id: "title", in: namespace)
                    Text(playMode.completeViewTitleExtension ?? "")
                }
                .font(.largeTitle.weight(.bold))
                Spacer()
            }
            .padding(.bottom)
            Text(playMode.completeViewCaption ?? "")
                .multilineTextAlignment(.center)
            
            VStack {
                ForEach(puzzle.questions) { question in
                    HStack {
                        Text(question.left.capitalized)
                        + Text(question.left == "" ? "" : "-")
                        + Text(question.formattedInsert).font(.body.weight(.bold))
                        + Text(question.right == "" ? "" : "-")
                        + Text(question.right)
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
            
            WelcomeViewButton(text: playMode.completeViewPrimaryButtonText ?? "", action: primaryButtonAction, primary: true)
                .padding(.top, 30)
            
            Spacer()
        }
        .foregroundColor(.white)
        .padding()
        .background(playMode.color)
    }
}

struct CompleteView_Previews: PreviewProvider {
    @Namespace static var namespace
    static var previews: some View {
        CompleteView(primaryButtonAction: {}, puzzle: Category.example.puzzle, playMode: .dailyPuzzle, namespace: namespace)
    }
}
