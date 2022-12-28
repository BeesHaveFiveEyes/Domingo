//
//  ArchiveView.swift
//  Wordout
//
//  Created by Alasdair Casperd on 04/11/2022.
//

import SwiftUI

struct ArchiveView: View {
    
    enum ArchiveViewState {
        case welcome
        case inProgress
        case complete
    }
    
    @Environment(\.presentationMode) var presentationMode
    
    @Namespace var namespace
    
    @State private var state: ArchiveViewState = .welcome
    
    @State private var puzzle = Category.example.puzzle
    
    func quit() {
        presentationMode.wrappedValue.dismiss()
    }
    
    func begin(date: Date) {
        puzzle = Puzzle.puzzleForDate(date)
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
            WelcomeView(playMode: .archive, primaryAction: begin, secondaryAction: quit, puzzle: puzzle, namespace: namespace)
        case .inProgress:
            PuzzleView(namespace: namespace, playMode: .archive, backAction: quit, complete: complete, puzzle: puzzle)
        case .complete:
            CompleteView(primaryButtonAction: quit, puzzle: puzzle, playMode: .archive, namespace: namespace)
        }
    }
}

struct ArchiveView_Previews: PreviewProvider {
    static var previews: some View {
        ArchiveView()
    }
}
