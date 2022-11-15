//
//  SettingsView.swift
//  Wordout
//
//  Created by Alasdair Casperd on 12/11/2022.
//

import SwiftUI

struct SettingsView: View {
    
    @AppStorage("HARDMODE") private var hardMode = false
    
    @State private var showingAlert = false
    
    private let alertTitle = "Reset all puzzles?"
    private let alertMessage = "This action cannot be undone."
    
    func resetProgress() {
        
        for category in Category.premadeCategories {
            
            var puzzle  = category.puzzle
            
            let newQuestions = puzzle.questions
            
            for question in newQuestions {
                question.guessed = false
            }
            
            puzzle = Puzzle(name: puzzle.name, description: puzzle.description, questions: newQuestions, symbolName: puzzle.symbolName, emoji: puzzle.emoji, dailyStyle: puzzle.dailyStyle)
            
            Progress.storeProgress(puzzle: puzzle)
        }
    }
    
    var body: some View {
        Form {
            Section(header: Text("Daily Puzzle Difficulty"),
                    footer: Text("When Hard Mode is enabled, the theme is category during daily and archived puzzles.")) {
                Toggle("Hard Mode", isOn: $hardMode)
            }
            Section(header: Text("Categories")) {
                Button("Reset Progress", role: .destructive) { showingAlert = true}
            }
            Section(header: Text("Other")) {
                Button("Restore Purchases") {}
                    .icon("arrow.counterclockwise")
                Button("Contact the Developer") {}
                    .icon("hand.wave.fill")
                Button("Submit a Puzzle Suggestion") {}
                    .icon("lightbulb.fill")
            }
        }
        .navigationTitle("Settings")
        .alert(alertTitle, isPresented: $showingAlert) {
            Button("Reset", role: .destructive) { showingAlert.toggle(); resetProgress() }
        } message: {
            Text(alertMessage)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
