
import SwiftUI

// A single item in the app's main menu

struct MainMenuItemView: View {
        
    // The title of the button
    var title: String
    
    // The SF symbol used to represent the item
    var symbolName: String?
    
    // A subtitle, if any is needed
    var subtitle: String? = nil
    
    // Should the menu item be accented?
    var accented: Bool = false
    
    // Is the menu item locked to the user?
    var locked: Bool = false
    
    // Should the menu item indicate that it has been completed with a check mark?
    var completed: Bool = false
    
    // The color used for the icon
    var iconColor: Color {
        accented ? Color.white : .accentColor
    }
    
    // The color used for the primary text
    var textColor: Color {
        accented ? .white : .primary
    }
    
    // The color used for the secondary text
    var secondaryTextColor: Color {
        accented ? .white : .secondary
    }
    
    // The background colour of the menu item
    var backgroundColor: Color {
        accented ? .accentColor : Color(UIColor.secondarySystemGroupedBackground)
    }
    
    var body: some View {
        
        HStack {
            
            // Icon
            
            Group {
                if let name = symbolName {
                    Image(systemName: name)
                }
                else {
                    Image("coda")
                }
            }
            .font(.title2)
            .frame(width: 30, height: 20, alignment: .center)
            .foregroundColor(iconColor)
            .padding(.trailing, 10)
            
            // Text
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(subtitle != nil ? .title2.weight(.bold) : .body)
                    .foregroundColor(textColor)
                if let s = subtitle {
                    Text(s)
                        .foregroundColor(textColor)
                }
            }
            
            Spacer()
            
            // Disclosure indicator or other icon
            
            Image(systemName: locked ? "lock.fill" : (completed ? "checkmark" : "chevron.right"))
                .foregroundColor(secondaryTextColor)
        }
        .padding()
        
        // Background
        
        .background(
            RoundedRectangle(cornerRadius: 15)
                .foregroundColor(backgroundColor)
        )
            
    }
}
