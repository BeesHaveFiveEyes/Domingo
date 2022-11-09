//
//  ContentView.swift
//  Wordout
//
//  Created by Alasdair Casperd on 03/11/2022.
//

import SwiftUI

struct ContentView: View {
    
    @State private var showingDailyView: Bool = false
    @State private var showingCategoriesView: Bool = false
    @State private var showingArchiveView: Bool = false
    @State private var showingCreateView: Bool = false
    @State private var showingImportView: Bool = false
    
    func onReturnToMenu() {
        
    }
    
    func enterDailyView() {
        showingDailyView = true
    }
    
    func enterArchiveView() {
        showingArchiveView = true
    }
    
    var body: some View {
        MainMenuView(enterDailyView: enterDailyView, enterArchiveView: enterArchiveView, enterCategoryView: {})
            .fullScreenCover(isPresented: $showingDailyView, onDismiss: onReturnToMenu) {
                DailyView()
                    .accentColor(PlayMode.dailyPuzzle.color)
            }
            .fullScreenCover(isPresented: $showingArchiveView, onDismiss: onReturnToMenu) {
                ArchiveView()
                    .accentColor(PlayMode.archive.color)
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
