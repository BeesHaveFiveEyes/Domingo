
import Foundation

// An item in one of the app's pop-up menus

struct MenuAction: Identifiable {
    
    // A unique identifier for the item
    let id = UUID()
    
    // A short description of the item's function
    var description: String
    
    // The SF symbol used for the item
    var symbolName: String
    
    // The action trigerred by the menu item
    var action: () -> ()
}
