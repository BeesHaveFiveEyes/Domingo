//
//  MainMenuView.swift
//  Wordout
//
//  Created by Alasdair Casperd on 03/11/2022.
//

import SwiftUI

struct MainMenuView: View {
    
    static public let smallWidthLimit: CGFloat = 400
    static public let mediumWidthLimit: CGFloat = 800
    
    var enterDailyView: () -> ()
    var enterArchiveView: () -> ()
    var enterCategoryView: () -> ()
    var enterCreateView: () -> ()
    var showPurchaseView: () -> ()
    var onReturnToMenu: () -> ()
    
    var showingStreak: Bool
    
    @EnvironmentObject var unlockManager: UnlockManager
    
    var fullAppUnlocked: Bool {
        return unlockManager.fullVersionUnlocked
    }
    
    @State private var titleTapped = false
    @State private var showingCategoriesView = false
    @State private var showingStatisticsView = false
    @State private var showingSettingsView = false
    
    private let animationDelay = 1.0
    
    var formattedDate: String {
        return Date().formatted(.dateTime.day().month(.wide))
    }
    
    var dailyPuzzle: Puzzle
    
    var dailySubtitle: String {
        let streak = Statistics.streak.value
        if Settings.streaksEnabled && streak > 0 {
            if dailyPuzzle.completed {
                return "\(streak) Day Streak"
            }
            else if dailyPuzzle.totalGuessed > 0 {
                return "\(dailyPuzzle.totalGuessed) / \(Puzzle.dailyPuzzleLength) Complete"
            }
            else {
                return "Continue your \(streak) day streak"
            }
        }
        else {
            if dailyPuzzle.completed {
                return "Completed for Today"
            }
            else if dailyPuzzle.totalGuessed > 0 {
                return "\(dailyPuzzle.totalGuessed) / \(Puzzle.dailyPuzzleLength) Complete"
            }
            else {
                return formattedDate
            }
        }
    }
    
    func showCategoriesView() {
        showingCategoriesView = true
    }
    
    var menuItems: some View {
        
        Group {
            
            // Daily Puzzle
            
            Button(action: enterDailyView) {
                MenuItemView(playMode: .dailyPuzzle, subtitle: dailySubtitle, completed: dailyPuzzle.completed, showingStreaks: showingStreak)
            }
            .fadeInAfter(offset: 0, withDelay: animationDelay)
            
            // Categories
            
            NavigationLink(destination: CategoriesView(showPurchaseView: showPurchaseView), isActive: $showingCategoriesView) {
                MenuItemView(playMode: .categories)
            }
            .onChange(of: showingCategoriesView) { newValue in
                if newValue == false {
                    onReturnToMenu()
                }
            }
            .fadeInAfter(offset: 1, withDelay: animationDelay)
            
            // Statistics
            
            NavigationLink(destination: StatisticsView(), isActive: $showingStatisticsView) {
                MenuItemView(playMode: .statistics)
            }
            .onChange(of: showingStatisticsView) { newValue in
                if newValue == false {
                    onReturnToMenu()
                }
            }
            .fadeInAfter(offset: 2, withDelay: animationDelay)
            
            // Archived Puzzles
            
            Button {
                if fullAppUnlocked {
                    enterArchiveView()
                } else {
                    showPurchaseView()
                }
            } label: {
                MenuItemView(playMode: .archive, locked: !fullAppUnlocked)
            }
            .fadeInAfter(offset: 3, withDelay: animationDelay)
            
            // Settings
            
            NavigationLink(destination: SettingsView(), isActive: $showingSettingsView) {
                MenuItemView(playMode: .settings)
            }
            .onChange(of: showingSettingsView) { newValue in
                if newValue == false {
                    onReturnToMenu()
                }
            }
            .fadeInAfter(offset: 4, withDelay: animationDelay)
        }
    }
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack(alignment: .leading, spacing: 15) {
                    
                    Spacer()
                    
                    HStack {
                        VStack(alignment: .leading) {

                            Text("\(Domingo.appName)")
                                .font(.system(size: UIFont.textStyleSize(.largeTitle) * 1.4, weight: .bold))
                                .fontWeight(.heavy)
                                .foregroundColor(.accentColor)
                                .slideInAfter(offset: 0)
                            Text("A Puzzle Game by Alasdair Casperd")
                                .font(.body)
                                .foregroundColor(.secondary)
                                .slideInAfter(offset: 1)
                        }
                        .animation(.spring())
                        Spacer()
                    }
                    .padding(.leading)
                    
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 15){
                        menuItems
                    }
                }
                
            }
            .padding()
            .background(Domingo.backgroundColor
                .edgesIgnoringSafeArea(.all))
        }
        .navigationViewStyle(.stack)
    }
}

struct MainMenuView_Previews: PreviewProvider {
    static var previews: some View {
        MainMenuView(enterDailyView: {}, enterArchiveView: {}, enterCategoryView: {}, enterCreateView: {}, showPurchaseView: {}, onReturnToMenu: {}, showingStreak: true, dailyPuzzle: Puzzle.dailyPuzzle)
            .accentColor(Domingo.themeColor)
    }
}

struct MenuItemView: View {
    
    var playMode: PlayMode
    var subtitle: String?
    var locked: Bool = false
    var completed: Bool = false
    var showingStreaks: Bool = false
    
    var iconColor: Color {
        playMode.menuAccent ? Color.white : playMode.color
    }
    
    var textColor: Color {
        playMode.menuAccent ? .white : .primary
    }
    
    var secondaryTextColor: Color {
        playMode.menuAccent ? .white : .secondary
    }
    
    var body: some View {
        HStack {
            
            // Icon
            
            Group {
                if playMode == .dailyPuzzle {
//                    if showingStreaks {
//                        Image(systemName: "flame.fill")
//                    }
//                    else {
                        Image("coda")
//                    }
                }
                else {
                    Image(systemName: playMode.symbolName)
                }
            }
            .font(.title2)
            .frame(width: 30, height: 20, alignment: .center)
            .foregroundColor(iconColor)
            .padding(.trailing, 10)
            
            // Text
            
            VStack(alignment: .leading) {
                Text(playMode.menuTitle)
                    .font(subtitle != nil ? .title2.weight(.bold) : .body)
                    .foregroundColor(textColor)
                if subtitle != nil {
                    Text(subtitle ?? "")
                        .foregroundColor(textColor)
                }
            }
            
            Spacer()
            
            // Disclosure indicator
            
            Image(systemName: locked ? "lock.fill" : (completed ? "checkmark" : "chevron.right"))
                .foregroundColor(secondaryTextColor)
        }
        .padding()
        
        // Background
        
        .background(
            RoundedRectangle(cornerRadius: 15)
                .foregroundColor(playMode.menuAccent ? playMode.color : Color(UIColor.secondarySystemGroupedBackground))
        )
            
    }
}
