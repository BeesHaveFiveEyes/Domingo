
import SwiftUI

// A view containing the app's settings and some external links

struct SettingsView: View {
    
    @EnvironmentObject var unlockManager: UnlockManager
    
    // App Storage settings (see 'Settings' class)
    @AppStorage("HARDMODE") private var hardMode = false
    @AppStorage("STREAKSENABLED") private var streaksEnabled = true
    
    // Alert properties
    @State private var showingAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var alertAction: () -> () = {}
    
    // The email address to be used for contact requests
    private let contactEmail = "domingo.puzzle@gmail.com"
    
    // Show a confirmation alert before resetting the user's progress
    func showResetProgressAlert() {
        alertTitle = "Reset all puzzles?"
        alertMessage = "This action cannot be undone."
        alertAction = DomingoEngine.resetCategoryProgress
        showingAlert = true
    }
    
    // Show a confirmation alert before resetting the user's statistics
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
            }
            
            Section(header: Text("App Progress")) {
                Button("Reset Statistics", role: .destructive, action: showResetStatisticsAlert)
                .icon("trophy", color: .red)
                Button("Reset Categories Progress", role: .destructive, action: showResetProgressAlert)
                .icon("books.vertical", color: .red)
            }
            
            Section(header: Text("Other Links")) {
                Button("Restore Purchases") { unlockManager.restore() }
                    .icon("arrow.counterclockwise")
                
                Button("Contact the Developer") {
                    EmailManager.shared.sendEmail(subject: "\(DomingoEngine.appName) Feedback", body: "", to: contactEmail)
                }
                .icon("hand.wave")
                
                Button("Submit a Puzzle Suggestion") {
                    EmailManager.shared.sendEmail(subject: "\(DomingoEngine.appName) Suggestion", body: "", to: contactEmail)
                }
                .icon("lightbulb")
                
                Link("Website", destination: URL(string: "https://domingo-app.com")!)
                .icon("link")
            }
        }
        .navigationTitle("Settings")
        .alert(alertTitle, isPresented: $showingAlert) {
            Button("Reset", role: .destructive, action: alertAction)
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
