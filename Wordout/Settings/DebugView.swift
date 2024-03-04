
import SwiftUI

// A view containing some debug information and admin operations
// Accessed by tapping the home screen title ten times in a row

struct DebugView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State private var uniqueIdentifier = Array(1000...9999).randomElement()!
    
    var versionNumber: String? {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Diagnostics")){
                    HStack {
                        Text("App Version Number")
                        Spacer()
                        Text(versionNumber ?? "Unknown")
                            .foregroundColor(.secondary)
                    }
                    HStack {
                        Text("Current Seed")
                        Spacer()
                        Text("\(Date().seed)")
                            .foregroundColor(.secondary)
                    }
                    HStack {
                        Text("Unique Identifier")
                        Spacer()
                        Text("\(uniqueIdentifier)")
                            .foregroundColor(.secondary)
                    }
                }
                
                Section(header: Text("Admin Operations")) {
                    NavigationLink("Restore Streak") {
                        StreakRestorationView(dismiss: {presentationMode.wrappedValue.dismiss()}, uniqueIdentifier: uniqueIdentifier)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .navigationTitle("Debug View")
        }
    }
}

struct DebugView_Previews: PreviewProvider {
    static var previews: some View {
        DebugView()
    }
}
