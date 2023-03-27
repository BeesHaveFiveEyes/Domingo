//
//  ContentView.swift
//  Wordout
//
//  Created by Alasdair Casperd on 03/11/2022.
//

import SwiftUI
import WidgetKit

struct ContentView: View {
    
    @Environment(\.scenePhase) var scenePhase
    
    @State private var showingDailyView: Bool = false
    @State private var showingCategoriesView: Bool = false
    @State private var showingArchiveView: Bool = false
    @State private var showingRandomView: Bool = false
    @State private var showingImportView: Bool = false
    @State private var showingInAppPurchaseView: Bool = false
    @State private var showingWidgetInstructionsView: Bool = false
    
    @State private var dailyPuzzle = Progress.loadStoredPuzzle(for: Puzzle.dailyPuzzle)
    
    @State private var welcomeTitle = ""
    @State private var welcomeCaption = ""
    
    @State private var showingStreak = false
    
    func onReturnToApp() {
        onReturnToMenu()
    }
    
    func onReturnToMenu() {
        dailyPuzzle = Progress.loadStoredPuzzle(for: Puzzle.dailyPuzzle)
        WidgetCenter.shared.reloadAllTimelines()
        Statistics.checkStreak()
        showingStreak = Settings.streaksEnabled
        
        var key = "HASSEENWIDGETINTRO"
        if !UserDefaults.standard.bool(forKey: key) && Statistics.dailyPuzzlesAttempted.value > 3 {
            if !(UIDevice.current.userInterfaceIdiom == .pad) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    showingWidgetInstructionsView = true
                }
            }
            UserDefaults.standard.set(true, forKey: key)
        }
        key = "CONFIGUREDSTREAKSETTING"
        if !UserDefaults.standard.bool(forKey: key) {
            Settings.streaksEnabled = true
            UserDefaults.standard.set(true, forKey: key)
        }
        
    }
    
    func enterDailyView() {
        showingDailyView = true
    }
    
    func enterArchiveView() {
        showingArchiveView = true
    }
    
    func enterRandomView() {
        showingRandomView = true
    }
    
    func showPurchaseView() {
        showingInAppPurchaseView = true
    }
    
    var body: some View {
        MainMenuView(enterDailyView: enterDailyView, enterArchiveView: enterArchiveView, enterCategoryView: {}, enterRandomView: enterRandomView, showPurchaseView: showPurchaseView, onReturnToMenu: onReturnToMenu, showingStreak: showingStreak, dailyPuzzle: dailyPuzzle)
            .fullScreenCover(isPresented: $showingDailyView, onDismiss: onReturnToMenu) {
                DailyView()
                    .accentColor(PlayMode.dailyPuzzle.color)
            }
            .fullScreenCover(isPresented: $showingArchiveView, onDismiss: onReturnToMenu) {
                ArchiveView()
                    .accentColor(PlayMode.archive.color)
            }
            .fullScreenCover(isPresented: $showingRandomView, onDismiss: onReturnToMenu) {
                RandomView()
                    .accentColor(PlayMode.archive.color)
            }
            .sheet(isPresented: $showingInAppPurchaseView) {
                InAppPurchaseView()
                    .accentColor(PlayMode.archive.color)
            }
            .sheet(isPresented: $showingWidgetInstructionsView, onDismiss: onReturnToMenu) {
                WidgetInstructionsView()
                    .accentColor(PlayMode.archive.color)
            }
            .onChange(of: scenePhase) { newPhase in
                if newPhase == .active {
                    onReturnToApp()
                }
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .accentColor(Domingo.themeColor)
    }
}
