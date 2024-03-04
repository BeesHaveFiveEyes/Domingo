
import SwiftUI

// A row view for the full unlock view highlighting a feature of the app

struct FullUnlockRowView: View {
    var symbolName: String?
    var description: String
    var body: some View {
        HStack {
            Group{
                if symbolName == nil {
                    Text(DomingoEngine.placeholder)
                        .font(.largeTitle)
                }
                else {
                    Image(systemName: symbolName!)
                }
            }
            .frame(width: 50, height: 50)
            .padding(.trailing, 5)
            .foregroundColor(.accentColor)
            .font(.title2)
            Text(description)
            Spacer()
            Image(systemName: "checkmark")
                .foregroundColor(.accentColor)
                .padding()
        }
    }
}
