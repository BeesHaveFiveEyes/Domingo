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
    @AppStorage("PLAINTEXTSHARING") private var plainTextSharing = false
    @AppStorage("ACCENTEDSHARING") private var accentedSharing = false
    @AppStorage("HIDEPROGRESS") private var hideProgress = false
    @AppStorage("STREAKSENABLED") private var streaksEnabled = true
    
    @State private var showingAlert = false
    @State private var showingAcknowledgements = false
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var alertAction: () -> () = {}
    
    private let contactEmail = "domingo.puzzle@gmail.com"
    
    func showResetProgressAlert() {
        alertTitle = "Reset all puzzles?"
        alertMessage = "This action cannot be undone."
        alertAction = Progress.resetAll
        showingAlert = true
    }
    
    func showResetStatisticsAlert() {
        alertTitle = "Reset daily puzzle statistics?"
        alertMessage = "This action cannot be undone."
        alertAction = Statistics.resetAll
        showingAlert = true
    }
    
    var body: some View {
        Form {
            Section(header: Text("Daily Puzzle"),
                    footer: Text("When Hard Mode is enabled, the theme is hidden during daily and archived puzzles.")) {
                Toggle("Show Streak", isOn: $streaksEnabled)
                    .icon("flame")                    
                Toggle("Hard Mode", isOn: $hardMode)
                    .icon("crown")
//                    .icon(hardMode ? "dial.high" : "dial.low")
            }
            
            Section(header: Text("App Progress")) {
                Button("Reset Statistics", role: .destructive, action: showResetStatisticsAlert)
                .icon("trophy", color: .red)
                Button("Reset Categories Progress", role: .destructive, action: showResetProgressAlert)
                .icon("books.vertical", color: .red)
            }
            
//            if #available(iOS 16.1, *) {
//                Section(header: Text("Puzzle Sharing")) {
//                    Toggle("Hide Progress", isOn: $hideProgress)
//                        .icon(hideProgress ? "eye.slash" : "eye")
//                    Toggle("Share as Plain Text", isOn: $plainTextSharing)
//                        .icon("textformat")
//                    Toggle("Accented Sharing", isOn: $accentedSharing)
//                        .icon("paintbrush")
//                    NavigationLink("Show Daily Puzzle Preview") {
//                        SharePuzzleView(puzzle: Progress.loadStoredPuzzle(for: Puzzle.dailyPuzzle))
//                    }
//                    .icon("plus.viewfinder")
//                }
//            }
            
            Section(header: Text("Other Links")) {
                Button("Restore Purchases") { unlockManager.restore() }
                    .icon("arrow.counterclockwise")
                
                Button("Contact the Developer") {
                    EmailManager.shared.sendEmail(subject: "\(Domingo.appName) Feedback", body: "", to: contactEmail)
                }
                .icon("hand.wave")
                
                Button("Submit a Puzzle Suggestion") {
                    EmailManager.shared.sendEmail(subject: "\(Domingo.appName) Suggestion", body: "", to: contactEmail)
                }
                .icon("lightbulb")
                
                Link("Website", destination: URL(string: "https://domingo-app.com")!)
                .icon("link")
                
                Button("Acknowledgements") {
                    showingAcknowledgements.toggle()
                }
                .icon("heart")
            }
        }
        .navigationTitle("Settings")
        .alert(alertTitle, isPresented: $showingAlert) {
            Button("Reset", role: .destructive, action: alertAction)
        } message: {
            Text(alertMessage)
        }
        .sheet(isPresented: $showingAcknowledgements) {
            ThanksView()
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
