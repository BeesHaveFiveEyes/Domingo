//
//  DailyView.swift
//  Wordout
//
//  Created by Alasdair Casperd on 03/11/2022.
//

import SwiftUI

struct DailyView: View {
    
    enum DailyViewState {
        case welcome
        case inProgress
        case complete
    }
    
    @Environment(\.presentationMode) var presentationMode
    
    @Namespace var namespace
    
    @State private var state: DailyViewState = .welcome
    
    func quit() {
        presentationMode.wrappedValue.dismiss()
    }
    
    func begin() {
        Progress.logDailyAttempt()
        withAnimation {
            state = .inProgress
        }
    }
    
    func complete() {
        Progress.logDailyCompletion()
        withAnimation {
            state = .complete
        }
    }
    
    var body: some View {
        switch state {
        case .welcome:
            WelcomeView(playMode: .dailyPuzzle, primaryAction: {date in begin()}, secondaryAction: quit, namespace: namespace)
        case .inProgress:
            PuzzleView(namespace: namespace, playMode: .dailyPuzzle, backAction: quit, complete: complete, puzzle: Puzzle.dailyPuzzle.loadingFromDailyProgress())
        case .complete:
            CompleteView(primaryButtonAction: quit, puzzle: .dailyPuzzle, playMode: .dailyPuzzle, namespace: namespace)
        }
    }
}

struct DailyView_Previews: PreviewProvider {
    static var previews: some View {
        DailyView()
    }
}
