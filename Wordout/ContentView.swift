//
//  ContentView.swift
//  Wordout
//
//  Created by Alasdair Casperd on 03/11/2022.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(\.scenePhase) var scenePhase
    
    @State private var showingDailyView: Bool = false
    @State private var showingCategoriesView: Bool = false
    @State private var showingArchiveView: Bool = false
    @State private var showingCreateView: Bool = false
    @State private var showingImportView: Bool = false
    @State private var showingInAppPurchaseView: Bool = false
    
    @State private var dailyPuzzle = Puzzle.dailyPuzzle.loadingFromDailyProgress()
    
    @State private var welcomeTitle = ""
    @State private var welcomeCaption = ""
    
    func onReturnToApp() {
        onReturnToMenu()
    }
    
    func onReturnToMenu() {
        dailyPuzzle = Puzzle.dailyPuzzle.loadingFromDailyProgress()
    }
    
    func enterDailyView() {
        showingDailyView = true
    }
    
    func enterArchiveView() {
        showingArchiveView = true
    }
    
    func enterCreateView() {
        showingCreateView = true
    }
    
    func showPurchaseView() {
        showingInAppPurchaseView = true
    }
    
    var body: some View {
        MainMenuView(enterDailyView: enterDailyView, enterArchiveView: enterArchiveView, enterCategoryView: {}, enterCreateView: enterCreateView, showPurchaseView: showPurchaseView, dailyPuzzle: dailyPuzzle)
            .fullScreenCover(isPresented: $showingDailyView, onDismiss: onReturnToMenu) {
                DailyView()
                    .accentColor(PlayMode.dailyPuzzle.color)
            }
            .fullScreenCover(isPresented: $showingArchiveView, onDismiss: onReturnToMenu) {
                ArchiveView()
                    .accentColor(PlayMode.archive.color)
            }
            .fullScreenCover(isPresented: $showingCreateView, onDismiss: onReturnToMenu) {
                CreateView()
                    .accentColor(PlayMode.archive.color)
            }
            .sheet(isPresented: $showingInAppPurchaseView) {
                InAppPurchaseView()
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
            .accentColor(WordoutApp.themeColor)
    }
}
