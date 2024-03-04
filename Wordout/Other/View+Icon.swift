
import SwiftUI

// A modifier to display an SF symbol icon to the left of a view

extension View {
    func icon(_ systemName: String, color: Color = .accentColor) -> some View {
        modifier(Icon(systemName: systemName, color: color))
    }
}

struct Icon: ViewModifier {
    
    var systemName: String
    var color: Color
    
    func body(content: Content) -> some View {
        HStack {
            Image(systemName: systemName)
                .frame(width: 20)
                .padding(.trailing, 5)
                .foregroundColor(color)
            content
        }
    }
}
