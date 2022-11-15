//
//  WordoutApp.swift
//  Wordout
//
//  Created by Alasdair Casperd on 03/11/2022.
//

import SwiftUI

@main
struct WordoutApp: App {
    
    static public let appName = "Domingo"
    static public let themeColor = Color("ThemeColor")
    static let placeholder = "❖"
    
    static public let animationIncrement = 0.06
    static public let animationDelay = 0.3
    static public let longAnimationDelay = 1.5
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .accentColor(WordoutApp.themeColor)
        }
    }
}
