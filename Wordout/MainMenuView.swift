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
    
//!!!!!    @EnvironmentObject var unlockManager: UnlockManager
    
//    var fullAppUnlocked: Bool {
//        return unlockManager.fullVersionUnlocked
//    }
    
    @State private var titleTapped = false
    @State private var showingCategoriesView = false
    
    private let animationDelay = 1.0
    
    var formattedDate: String {
        return Date().formatted(.dateTime.day().month(.wide))
    }
    
    var dailyPuzzle: Puzzle
    
    var dailySubtitle: String {
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
    
    func showCategoriesView() {
        showingCategoriesView = true
    }
    
    var menuItems: some View {
        
        Group {
            // Daily Puzzle
            
            Button(action: enterDailyView) {
                MenuItemView(playMode: .dailyPuzzle, subtitle: dailySubtitle)
            }
            .fadeInAfter(offset: 0, withDelay: animationDelay)
            
            // Categories
            
            NavigationLink(destination: CategoriesView(showPurchaseView: showPurchaseView), isActive: $showingCategoriesView) {
                MenuItemView(playMode: .categories)
            }
            .fadeInAfter(offset: 1, withDelay: animationDelay)
            
            // Statistics
            
            NavigationLink(destination: StatisticsView()) {
                MenuItemView(playMode: .statistics)
            }
            .fadeInAfter(offset: 2, withDelay: animationDelay)
            
            // Archived Puzzles
            
            Button {
                if true {
    //!!!!!                    if fullAppUnlocked {
                    enterArchiveView()
                } else {
                    showPurchaseView()
                }
            } label: {
                MenuItemView(playMode: .archive)
    //!!!!!                locked: !fullAppUnlocked)
            }
            .fadeInAfter(offset: 3, withDelay: animationDelay)
            
            // Settings
            
            NavigationLink(destination: SettingsView()) {
                MenuItemView(playMode: .settings)
            }
            .fadeInAfter(offset: 4, withDelay: animationDelay)
        }
    }
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack(alignment: .leading, spacing: 15) {
                
                    Spacer()
                    
                    // App Logo
                    
                    HStack {
                        VStack(alignment: .leading) {

                            Text("\(WordoutApp.appName)")
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
            .background(Color(UIColor.systemGroupedBackground)
                .edgesIgnoringSafeArea(.all))
        }
        .navigationViewStyle(.stack)
    }
}

struct MainMenuView_Previews: PreviewProvider {
    static var previews: some View {
        MainMenuView(enterDailyView: {}, enterArchiveView: {}, enterCategoryView: {}, enterCreateView: {}, showPurchaseView: {}, dailyPuzzle: Puzzle.dailyPuzzle.loadingFromDailyProgress())
            .accentColor(WordoutApp.themeColor)
    }
}

struct MenuItemView: View {
    
    var playMode: PlayMode
    var subtitle: String?
    var locked: Bool = false
    
    var iconColor: Color {
        if UIScreen.screenWidth < MainMenuView.smallWidthLimit {
            return playMode.menuAccent ? Color.white : playMode.color
        }
        else {
            return .accentColor
        }
    }
    
    var textColor: Color {
        if UIScreen.screenWidth < MainMenuView.smallWidthLimit {
            return playMode.menuAccent ? .white : .primary
        }
        else {
            return .primary
        }
    }
    
    var secondaryTextColor: Color {
        if UIScreen.screenWidth < MainMenuView.smallWidthLimit {
            return playMode.menuAccent ? .white : .secondary
        }
        else {
            return .secondary
        }
    }
    
    var body: some View {
        HStack {
            Group {
                if playMode == .dailyPuzzle {
                    Text(WordoutApp.placeholder)
                        .font(.largeTitle)
                }
                else {
                    Image(systemName: playMode.symbolName)
                        .font(.title2)
                }
            }
            .frame(width: 40, height: 20, alignment: .leading)
            .foregroundColor(iconColor)
            VStack(alignment: .leading) {
                if UIScreen.screenWidth < MainMenuView.smallWidthLimit {
                    Text(playMode.menuTitle)
                        .font(subtitle != nil ? .title2.weight(.bold) : .body)
                        .foregroundColor(textColor)
                    if subtitle != nil {
                        Text(subtitle ?? "")
                            .foregroundColor(textColor)
                    }
                }
                else {
                    Text("\(playMode.menuTitle)\(subtitle == nil ? "" : ", \(subtitle!)")")
                        .foregroundColor(textColor)
                        .font(.title3)
                }
            }
            Spacer()
            Image(systemName: locked ? "lock.fill" : "chevron.right")
                .foregroundColor(secondaryTextColor)
        }
        .padding()
        .background(
            Group {
                if UIScreen.screenWidth < MainMenuView.smallWidthLimit {
                    RoundedRectangle(cornerRadius: 15)
                        .foregroundColor(playMode.menuAccent ? playMode.color : Color(UIColor.secondarySystemGroupedBackground))
                }
                else {
                    EmptyView()
                }
            }
        )
            
    }
}
