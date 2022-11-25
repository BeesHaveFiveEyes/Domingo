//
//  SettingsView.swift
//  Wordout
//
//  Created by Alasdair Casperd on 12/11/2022.
//

import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject var unlockManager: UnlockManager
    
    @AppStorage("HARDMODE") private var hardMode = false
    
    @State private var showingAlert = false
    @State private var showingAcknowledgements = false
    
    private let alertTitle = "Reset all puzzles?"
    private let alertMessage = "This action cannot be undone."
    
    private let contactEmail = "domingo.puzzle@gmail.com"
    
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
                    footer: Text("When Hard Mode is enabled, the theme is hidden during daily and archived puzzles.").padding(.vertical)) {
                Toggle("Hard Mode", isOn: $hardMode)
            }
            Section(header: Text("App Progress")) {
                Button("Reset Statistics", role: .destructive) {
                    Progress.resetStatistics()
                    
                }
                .icon("trophy", color: .red)
                Button("Reset Categories Progress", role: .destructive) { showingAlert = true
                    
                }
                .icon("books.vertical", color: .red)
            }
            Section(header: Text("Other Links")) {
                Button("Restore Purchases") { unlockManager.restore() }
                    .icon("arrow.counterclockwise")
                Button("Contact the Developer") {
                    EmailManager.shared.sendEmail(subject: "\(WordoutApp.appName) Feedback", body: "", to: contactEmail)
                }
                    .icon("hand.wave.fill")
                Button("Submit a Puzzle Suggestion") {
                    EmailManager.shared.sendEmail(subject: "\(WordoutApp.appName) Suggestion", body: "", to: contactEmail)
                }
                    .icon("lightbulb.fill")
//                Button("Acknowledgements") {
//                    showingAcknowledgements.toggle()
//                }
//                .icon("heart.fill")
            }
        }
        .navigationTitle("Settings")
        .alert(alertTitle, isPresented: $showingAlert) {
            Button("Reset", role: .destructive) { showingAlert.toggle(); resetProgress() }
        } message: {
            Text(alertMessage)
        }
//        .sheet(isPresented: $showingAcknowledgements) {
//            VStack(alignment: .leading) {
//                Text("Thanks to all the amazing people who helped make \(WordoutApp.appName) a reality.)
//            }
//            .padding()
//        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
