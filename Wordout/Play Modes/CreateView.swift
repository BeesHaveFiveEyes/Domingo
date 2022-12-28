//
//  CategoryView.swift
//  Wordout
//
//  Created by Alasdair Casperd on 11/11/2022.
//

import SwiftUI

struct CreateView: View {
    
    enum CreateViewState {
        case welcome
        case creating
        case complete
    }
    
    @Environment(\.presentationMode) var presentationMode
    
    @Namespace var namespace
    
    var onCompletion: () -> () = {}
    
    @State private var state: CreateViewState = .welcome
    
    var category: Category = Category(name: "", description: nil, questions: [Question](), symbolName: "", emoji: "")
    
    func quit() {
        onCompletion()
        presentationMode.wrappedValue.dismiss()
    }
    
    func begin() {
        withAnimation {
            state = .creating
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
            WelcomeView(playMode: .createPuzzle, primaryAction: {date in begin()}, secondaryAction: quit, puzzle: Puzzle.dailyPuzzle, namespace: namespace)
        case .creating:
            NewCategoryView(dismiss: quit)
        case .complete:
            CompleteView(primaryButtonAction: quit, puzzle: .dailyPuzzle, playMode: .dailyPuzzle, namespace: namespace)
        }
    }
}

struct CreateView_Previews: PreviewProvider {
    static var previews: some View {
        CreateView()
    }
}
