
import Foundation

// A class used to store certain user preferences
// These settings are stored via @AppStorage in SettingsView

class Settings {
        
    // Has the user enabled hard mode?
    public static var hardModeEnabled: Bool {
        let key = "HARDMODE"
        return UserDefaults.standard.bool(forKey: key)
    }
    
    // Are streaks enabled in the app
    public static var streaksEnabled: Bool {
        get {
            let key = "STREAKSENABLED"
            return UserDefaults.standard.bool(forKey: key)
        }
        set {
            let key = "STREAKSENABLED"
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}
