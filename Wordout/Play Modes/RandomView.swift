//
//  RandomView.swift
//  Wordout
//
//  Created by Alasdair Casperd on 06/01/2023.
//

import SwiftUI

//
//  DailyView.swift
//  Wordout
//
//  Created by Alasdair Casperd on 03/11/2022.
//

import SwiftUI

struct RandomView: View {
    
    enum RandomViewState {
        case welcome
        case inProgress
        case complete
    }
    
    @Environment(\.presentationMode) var presentationMode
    
    @Namespace var namespace
    
    @State private var state: RandomViewState = .welcome
    @State private var puzzle = Puzzle.randomPuzzle()
    
    func quit() {
        presentationMode.wrappedValue.dismiss()
    }
    
    func begin() {
        withAnimation {
            state = .inProgress
        }
    }
    
    func complete() {
        withAnimation {
            state = .complete
        }
    }
    
    var body: some View {
        switch state {
        case .welcome:
            WelcomeView(playMode: .randomPuzzle, primaryAction: {date in begin()}, secondaryAction: quit, puzzle: puzzle, namespace: namespace)
        case .inProgress:
            PuzzleView(namespace: namespace, playMode: .randomPuzzle, backAction: quit, complete: complete, puzzle: puzzle)
        case .complete:
            CompleteView(primaryButtonAction: quit, puzzle: puzzle, playMode: .randomPuzzle, namespace: namespace)
        }
    }
}

struct RandomView_Previews: PreviewProvider {
    static var previews: some View {
        RandomView()
    }
}
