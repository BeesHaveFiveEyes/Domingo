
import SwiftUI

// A button with a short capsule shape, used in welcome views and complete views

struct PanelButton: View {
    
    var text: String
    var action: () -> ()
    var primary: Bool
    
    var body: some View {
        Button(action: action) {
            Text(text)
                .foregroundColor(primary ? Color.accentColor : Color.white)
                .padding(.vertical)
                .frame(width: 150)
                .background(
                    Capsule()
                        .foregroundColor(primary ? Color.white : Color.black)
                        .opacity(primary ? 1 : 0.1)
                )
        }
    }
}
