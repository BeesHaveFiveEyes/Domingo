
import SwiftUI
import WidgetKit

// The root view of the app

struct ContentView: View {
    
    @EnvironmentObject var mainMenuModel: MainMenuModel
    @Environment(\.scenePhase) var scenePhase
    
    var body: some View {
        MainMenuView()
            .fullScreenCover(isPresented: $mainMenuModel.showingDailyView, onDismiss: mainMenuModel.onReturnToMenu) {
                GameView(gameModel: GameModel(gameMode: .dailyPuzzle, quit: mainMenuModel.returnToMenu))
            }
            .fullScreenCover(isPresented: $mainMenuModel.showingArchiveView, onDismiss: mainMenuModel.onReturnToMenu) {
                GameView(gameModel: GameModel(gameMode: .archivedPuzzle, quit: mainMenuModel.returnToMenu))
            }
            .fullScreenCover(isPresented: $mainMenuModel.showingRandomView, onDismiss: mainMenuModel.onReturnToMenu) {
                GameView(gameModel: GameModel(gameMode: .randomPuzzle, quit: mainMenuModel.returnToMenu))
            }
            .sheet(isPresented: $mainMenuModel.showingInAppPurchaseView, onDismiss: mainMenuModel.onReturnToMenu) {
                InAppPurchaseView()
            }
            .fullScreenCover(isPresented: $mainMenuModel.showingDebugView, onDismiss: mainMenuModel.onReturnToMenu) {
                DebugView()
            }
            .onChange(of: scenePhase) { newPhase in
                if newPhase == .active {
                    mainMenuModel.onReturnToApp()
                }
            }
    }
}

#Preview {
    ContentView()
        .accentColor(DomingoEngine.themeColor)
        .environmentObject(MainMenuModel())
        .environmentObject(UnlockManager(previewValue: true))
}
