//
//  TopBarView.swift
//  Wordout
//
//  Created by Alasdair Casperd on 07/11/2022.
//

import SwiftUI

struct TopBarView: View {
    
    var title: String
    var namespace: Namespace.ID
    var backAction: () -> ()
    var menuActions: [MenuAction]        
    
    var body: some View {
        HStack {
            Button(action: backAction) {
                Image(systemName: "chevron.left")
                    .frame(width: 15)
            }
            Spacer()
            VStack {
                Text(title)
                    .matchedGeometryEffect(id: "title", in: namespace)
                .font(.largeTitle.weight(.bold))
            }
            Spacer()
            PuzzleOptionsButton(menuActions: menuActions)
        }
        .font(.title2)
        .padding()
    }
}
