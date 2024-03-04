
import SwiftUI

// The main menu of the app

struct MainMenuView: View {
    
    @EnvironmentObject var mainMenuModel: MainMenuModel
    @EnvironmentObject var unlockManager: UnlockManager
    
    var lockPaidContent: Bool {
        return !unlockManager.fullVersionUnlocked
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 15) {
                Spacer()
                HStack {
                    VStack(alignment: .leading) {
                        
                        // App Title
                        
                        Text("\(DomingoEngine.appName)")
                            .font(.system(size: UIFont.textStyleSize(.largeTitle) * 1.4, weight: .bold))
                            .fontWeight(.heavy)
                            .foregroundColor(.accentColor)
                            .slideInAfter(offset: 0)
                            .onTapGesture(count: 10, perform: mainMenuModel.showDebugView)
                        
                        // App Caption
                        
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
                
                // Menu Items
                
                VStack(alignment: .leading, spacing: 15){
                    
                    // Daily Puzzle
                    
                    Button(action: mainMenuModel.showDailyView) {
                        MainMenuItemView(title: "Daily Puzzle", subtitle: mainMenuModel.dailyPuzzleSubtitle, accented: true, completed: DomingoEngine.dailyPuzzleCompleted)
                    }
                    .fadeInAfter(offset: 0, withDelay: mainMenuModel.animationDelay)
                    
                    // Categories
                    
                    NavigationLink(destination: CategoriesView(), isActive: $mainMenuModel.showingCategoriesView) {
                        MainMenuItemView(title: "Categories", symbolName: "books.vertical.fill")
                    }
                    .fadeInAfter(offset: 1, withDelay: mainMenuModel.animationDelay)
                    
                    // Statistics
                    
                    NavigationLink(destination: StatisticsView(), isActive: $mainMenuModel.showingStatisticsView) {
                        MainMenuItemView(title: "Statistics", symbolName: "trophy.fill")
                    }
                    .fadeInAfter(offset: 2, withDelay: mainMenuModel.animationDelay)
                    
                    // Archived Puzzles
                    
                    Button(action: { if lockPaidContent { mainMenuModel.showInAppPurchaseView() } else { mainMenuModel.showArchiveView() }}) {
                        MainMenuItemView(title: "Archive", symbolName: "archivebox.fill", locked: lockPaidContent)
                    }
                    .fadeInAfter(offset: 3, withDelay: mainMenuModel.animationDelay)
                    
                    // Settings
                    
                    NavigationLink(destination: SettingsView(), isActive: $mainMenuModel.showingSettingsView) {
                        MainMenuItemView(title: "Settings", symbolName: "gearshape.fill")
                    }
                    .fadeInAfter(offset: 4, withDelay: mainMenuModel.animationDelay)
                }
            }
            .padding()
            .background(DomingoEngine.backgroundColor
                .edgesIgnoringSafeArea(.all))
        }
        .navigationViewStyle(.stack)
    }
}

#Preview {
    ContentView()
        .accentColor(DomingoEngine.themeColor)
        .environmentObject(MainMenuModel())
        .environmentObject(UnlockManager(previewValue: false))
}
