//
//  WordoutApp.swift
//  Wordout
//
//  Created by Alasdair Casperd on 03/11/2022.
//

import SwiftUI

@main
struct WordoutApp: App {
    
    init() {        
        let unlockManager = UnlockManager()
        _unlockManager = StateObject(wrappedValue: unlockManager)
    }
    
    @StateObject var unlockManager: UnlockManager
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .accentColor(Domingo.themeColor)
                .environmentObject(unlockManager)
        }
    }
}
