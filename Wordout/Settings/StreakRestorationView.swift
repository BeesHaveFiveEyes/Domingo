
import SwiftUI

// A view used to restore a user's streak in case of complaints

struct StreakRestorationView: View {
    
    @State private var text = ""
    
    @State private var showingAlert = false
    @State private var alertText = ""
    @State private var onAlertDismiss: () -> () = {}
    
    var dismiss: () -> ()
    var uniqueIdentifier: Int
    
    // Check if the password entered is the first five digits of (uniqueIdentifier * Pi)
    func validatePassword() {

        let correctPasswordNumber = Double(uniqueIdentifier) * Double.pi
        let passwordParts = "\(correctPasswordNumber)".split(separator: ".")
        if passwordParts.count > 1 {
            let correctPassword = passwordParts[1].prefix(5)
            if String(text) == String(correctPassword) {
                restoreStreak()
                alertText = "Streak Restoration Successful"
                onAlertDismiss = dismiss
                showingAlert = true
                return
            }
        }
        if text != "" {
            alertText = "Invalid Streak Restoration Key"
            onAlertDismiss = {}
            showingAlert = true
        }
    }

    // Restore the user's streak to their longest recorded streak
    func restoreStreak() {
        Statistics.logDailyPuzzleCompletion()
        Statistics.currentStreak.replace(with: Statistics.longestStreak.value)
    }
    
    var body: some View {
        Form {
            Section {
                SecureField("Enter key...", text: $text)
                    .icon("lock")
                    .submitLabel(.go)
                    .onSubmit {
                        validatePassword()
                    }
            } header: {
                VStack {
                    Text("Enter a valid Streak Restoration Key below to restore your streak.")
                }
                .font(.body)
                .foregroundColor(.primary)
                .textCase(.none)
                .padding(.horizontal, -16)
                .padding(.bottom)
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Submit") {
                    validatePassword()
                }
                .disabled(text == "")
            }
        }
        .navigationTitle("Restore Streak")
        .alert(alertText, isPresented: $showingAlert) {
            Button("OK", action: onAlertDismiss)
        }
    }
}
