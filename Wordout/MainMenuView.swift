//
//  MainMenuView.swift
//  Wordout
//
//  Created by Alasdair Casperd on 03/11/2022.
//

import SwiftUI

struct MainMenuView: View {
    
    var enterDailyView: () -> ()
    var enterArchiveView: () -> ()
    var enterCategoryView: () -> ()
    var enterCreateView: () -> ()
    var showPurchaseView: () -> ()
    
    @EnvironmentObject var unlockManager: UnlockManager
    
    var fullAppUnlocked: Bool {
        return unlockManager.fullVersionUnlocked
    }
    
    @State private var titleTapped = false
    @State private var showingCategoriesView = false
    
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
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 15) {
                Spacer()
                HStack {
                    VStack(alignment: .leading) {
                        
//                        Text("Welcome Back, \(name).")
//                            .font(.largeTitle)
//                            .fontWeight(.heavy)
//                            .foregroundColor(.accentColor)
//                        Text("A new daily puzzle is waiting for you.")
//                            .font(.body)
//                            .foregroundColor(.secondary)
                        Text("\(WordoutApp.appName)")
                            .font(.system(size: UIFont.textStyleSize(.largeTitle) * 1.4, weight: .bold))
                            .fontWeight(.heavy)
                            .foregroundColor(.accentColor)
//                        Image("Coda")
//                            .resizable()
//                            .scaledToFit()
//                            .frame(height: 80)
//                            .slideInAfter(0)
//                            .scaleEffect(titleTapped ? 1.04 : 1)
//                            .animation(.spring(response: 0.4, dampingFraction: 0.6))
//                            .onTapGesture {
//                                titleTapped = true
//                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                                    titleTapped = false
//                                }
//                            }
                        Text("A Puzzle Game by Alasdair Casperd")
                            .font(.body)
                            .foregroundColor(.secondary)
//                            .offset(x: 14, y:-10)
//                            .slideInAfter(0.3)
//                            .animation(.spring(response: 0.4, dampingFraction: 0.6))
                    }
                    Spacer()
                }
                .padding(.leading)
                
                Spacer()                
                
                Button(action: enterDailyView) {
                    MenuItemView(playMode: .dailyPuzzle, subtitle: dailySubtitle)
                }
//                .slideInAfter(offset: 0, withDelay: 2)
                
                NavigationLink(destination: CategoriesView(showPurchaseView: showPurchaseView), isActive: $showingCategoriesView) {
                    MenuItemView(playMode: .categories)
                }
//                .slideInAfter(offset: 0, withDelay: 2)
                
//                Button(action: enterCreateView) {
//                MenuItemView(playMode: .createPuzzle)
//                }
//                    .slideInAfter(offset: 0, withDelay: 2)
////                Button(action: {}) {
//                MenuItemView(playMode: .importPuzzle, locked: true)
////                }
//                    .slideInAfter(offset: 0, withDelay: 2)
                
                NavigationLink(destination: StatisticsView()) {
                    MenuItemView(playMode: .statistics)
                }
//                .slideInAfter(offset: 0, withDelay: 2)
                
                Button {
                    if fullAppUnlocked {
                        enterArchiveView()
                    } else {
                        showPurchaseView()
                    }
                } label: {
                    MenuItemView(playMode: .archive, locked: !fullAppUnlocked)
                }
//                .slideInAfter(offset: 0, withDelay: 2)
                
                NavigationLink(destination: SettingsView()) {
                    MenuItemView(playMode: .settings)
                }
//                .slideInAfter(offset: 0, withDelay: 2)
            }
            .padding()
            .background(Color(UIColor.systemGroupedBackground)
                .edgesIgnoringSafeArea(.all))
        }
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
            .foregroundColor(playMode.menuAccent ? Color.white : playMode.color)
            VStack(alignment: .leading) {
                Text(playMode.menuTitle)
                    .font(subtitle != nil ? .title2.weight(.bold) : .body)
                    .foregroundColor(playMode.menuAccent ? .white : .primary)
                if subtitle != nil {
                    Text(subtitle ?? "")
                        .foregroundColor(playMode.menuAccent ? .white : .primary)
                }
            }
            Spacer()
            Image(systemName: locked ? "lock.fill" : "chevron.right")
                .foregroundColor(playMode.menuAccent ? .white : .secondary)
        }
        .padding()
        .background(
        RoundedRectangle(cornerRadius: 15)
            .foregroundColor(playMode.menuAccent ? playMode.color : Color(UIColor.secondarySystemGroupedBackground)))
    }
}
