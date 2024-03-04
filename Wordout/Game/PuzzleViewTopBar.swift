
import SwiftUI

// The control bar at the top of the puzzle views, showing a back button, the puzzle name and a menu

struct PuzzleViewTopBar: View {
    
    @EnvironmentObject var gameModel: GameModel
    var namespace: Namespace.ID
    
    var body: some View {
        HStack {
            
            // Back Button
            
            Button(action: gameModel.quit) {
                Image(systemName: "chevron.left")
                    .frame(width: 15)
            }
            
            Spacer()
            
            // Title
            
            VStack {
                Text(gameModel.gameModeName)
                    .matchedGeometryEffect(id: "title", in: namespace)
                    .font(.largeTitle.weight(.bold))
            }
            
            Spacer()
            
            // Menu
            
            Menu {
                ForEach(gameModel.menuActions) { menuAction in
                    Button(action: menuAction.action) {
                        Label(menuAction.description, systemImage: menuAction.symbolName)
                    }
                }
            } label: {
                Image(systemName: "ellipsis.circle")
            }
        }
        .font(.title2)
        .padding()
    }
}
