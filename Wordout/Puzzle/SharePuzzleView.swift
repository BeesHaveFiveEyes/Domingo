//
//  SharePuzzleView.swift
//  Wordout
//
//  Created by Alasdair Casperd on 30/11/2022.
//

import SwiftUI

struct SharePuzzleView: View {
        
    public static var scale: CGFloat = 1
        
    var puzzle: Puzzle
    var category: Category?
    
    var accented = Settings.accentedSharing    
    
    var formattedDate: String {
        let date = Date.dateForSeed(Progress.lastAttemptedSeed.value)
        return date.formatted(.dateTime.day().month(.wide))
    }
    
    var categoryFooter: some View {
        Group {
            if !Settings.hardModeOn {
                HStack {
                    Text("The category is")
                    Image(systemName: puzzle.symbolName)
                    Text(puzzle.name)
                }
            }
            else {
                Text("The category is hidden in Hard Mode")
            }
        }
        .font(.system(size: 19*SharePuzzleView.scale))
        .padding()
    }
    
    var body: some View {

        VStack {
            Spacer()
            HStack {
                
                VStack(alignment: .leading) {
                    Text("Daily Puzzle")
                        .font(.system(size: 34*SharePuzzleView.scale))
                        .fontWeight(.bold)
                    Text("\(formattedDate) - \(Settings.hardModeOn ? "Hard Mode" : puzzle.name)")
                        .font(.system(size: 19*SharePuzzleView.scale))
                        .foregroundColor(accented ? .white : .secondary)
                    
                }
                Spacer()
                Image(systemName: puzzle.symbolName)
                    .font(.largeTitle)
                    .padding(.horizontal)
                    .foregroundColor(accented ? .white : Domingo.themeColor)
            }
            .padding(.horizontal)
            .padding(.bottom)
            
            ForEach(puzzle.questions) { question in
                if accented {
                    QuestionView(category: category, question: question, guessed: (Settings.hideProgress ? false : question.guessed), textColor: .white, placeholderColor: .white, backgroundColor: .black, backgroundOpacity: 0.1)
                }
                else {
                    QuestionView(category: category, question: question, guessed: (Settings.hideProgress ? false : question.guessed))
                }
            }
            .font(.system(size: 19*SharePuzzleView.scale))
    
            Spacer()
        }
        .accentColor(Domingo.themeColor)
        .foregroundColor(accented ? .white : .primary)
        .background((accented ? Domingo.themeColor : Domingo.backgroundColor).edgesIgnoringSafeArea(.all))
    }
}

struct SharePuzzleView_Previews: PreviewProvider {
    static var previews: some View {
        SharePuzzleView(puzzle: Puzzle.dailyPuzzle, category: Category.example)
    }
}
