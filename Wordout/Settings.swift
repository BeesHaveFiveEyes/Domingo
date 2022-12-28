//
//  Settings.swift
//  Wordout
//
//  Created by Alasdair Casperd on 26/11/2022.
//

import Foundation


class Settings {
    
    // Settings are stored via @AppStorage in SettingsView
    
    public static var hardModeOn: Bool {
        let key = "HARDMODE"
        return UserDefaults.standard.bool(forKey: key)
    }
    
    public static var publicityFeatures: Bool {
        let key = "PUBLICITYFEATURES"
        return UserDefaults.standard.bool(forKey: key)
    }
    
    public static var plainTextSharing: Bool {
        let key = "PLAINTEXTSHARING"
        return UserDefaults.standard.bool(forKey: key)
    }
    
    public static var accentedSharing: Bool {
        let key = "ACCENTEDSHARING"
        return UserDefaults.standard.bool(forKey: key)
    }
    
    public static var hideProgress: Bool {
        let key = "HIDEPROGRESS"
        return UserDefaults.standard.bool(forKey: key)
    }
    
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
