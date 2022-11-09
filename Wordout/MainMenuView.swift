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
    
    var formattedDate: String {
        return Date().formatted(.dateTime.day().month(.wide))
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 15) {
                Spacer()
                Text("HOSHI")
                    .foregroundColor(.accentColor)
                    .font(.largeTitle.weight(.black))
                    .padding(.leading)
                Text("A puzzle game by Alasdair Casperd")
                    .foregroundColor(.secondary)
                    .padding(.leading)
                
                
                Spacer()                
                
                Button(action: enterDailyView) {
                    MenuItemView(playMode: .dailyPuzzle, subtitle: formattedDate)
                }
                
                NavigationLink(destination: CategoriesView()) {
                    MenuItemView(playMode: .categories)
                }
                
                Button(action: {}) {
                    MenuItemView(playMode: .createPuzzle, locked: true)
                }
                
                Button(action: {}) {
                    MenuItemView(playMode: .importPuzzle, locked: true)
                }
                
                Button(action: enterArchiveView) {
                    MenuItemView(playMode: .archive)
                }
            }
            .padding()
            .background(Color(UIColor.systemGroupedBackground)
                .edgesIgnoringSafeArea(.all))
        }
    }
}

struct MainMenuView_Previews: PreviewProvider {
    static var previews: some View {
        MainMenuView(enterDailyView: {}, enterArchiveView: {}, enterCategoryView: {})
    }
}

struct MenuItemView: View {
    
    var playMode: PlayMode
    var subtitle: String?
    var locked: Bool = false
    
    var body: some View {
        HStack {
            Image(systemName: playMode.symbolName)
                .frame(width: 40, height: 20, alignment: .leading)
                .font(.title2)
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
