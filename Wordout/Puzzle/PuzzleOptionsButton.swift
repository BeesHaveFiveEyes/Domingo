//
//  PuzzleOptionsButton.swift
//  Wordout
//
//  Created by Alasdair Casperd on 07/11/2022.
//

import SwiftUI

struct MenuAction: Identifiable {
    var id: Int
    var description: String
    var symbolName: String
    var action: () -> ()
}

struct PuzzleOptionsButton: View {
    
    var menuActions: [MenuAction]
    
    var body: some View {
        if menuActions.count == 0 {
            Image(systemName: "face.smiling.inverse")
                .foregroundColor(.accentColor)
        }
        else if menuActions.count == 1 {
            Button(action: menuActions[0].action) {
                Image(systemName: menuActions[0].symbolName)
            }
        }
        else {
            Menu {
                ForEach(menuActions) { menuAction in
                    Button(action: menuAction.action) {
                        Label(menuAction.description, systemImage: menuAction.symbolName)
                    }
                }
            } label: {
                Image(systemName: "ellipsis.circle")
            }
        }
    }
}

struct PuzzleOptionsButton_Previews: PreviewProvider {
    static var previews: some View {
        PuzzleOptionsButton(menuActions: [MenuAction]())
    }
}
