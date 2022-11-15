//
//  PuzzleView.swift
//  Wordout
//
//  Created by Alasdair Casperd on 03/11/2022.
//

import SwiftUI

struct PuzzleView: View {
    
    var namespace: Namespace.ID
    
    var playMode: PlayMode
    
    var backAction: () -> ()
    var complete: () -> ()
    
    var category: Category?
    
    @FocusState var textFieldFocused: Bool
    
    @State var puzzle: Puzzle
    @State private var input = ""
    
    @State private var showingInstructions = false
    @State private var showingYesterdaysAnswers = false
    @State private var showingResetWarning = false
    
    var title: String {
        if category == nil {
            return playMode.name
        }
        else if playMode == .dailyPuzzle {
            return playMode.name
        }
        else {
            return category!.name
        }
    }
    
    private var menuActions: [MenuAction] {
        
        var output = [MenuAction]()
        
        // How to Play
        output.append(MenuAction(id: 0, description: "How to Play", symbolName: "questionmark.circle", action: {showingInstructions = true}))
        
        // Yesterday's Answers
        if playMode == .dailyPuzzle {
            output.append(MenuAction(id: 1, description: "Yesterday's Answers", symbolName: "doc.text.magnifyingglass", action: {showingYesterdaysAnswers = true}))
        }
        
        // Reset progress
        if puzzle.totalGuessed > 0 {
            output.append(MenuAction(id: 2, description: "Reset Progress", symbolName: "arrow.counterclockwise", action: {showingResetWarning = true}))
        }
        
        return output
    }
    
    func resetProgress() {
        
        let newQuestions = puzzle.questions
        
        for question in newQuestions {
            question.guessed = false
        }
        
        puzzle = Puzzle(name: puzzle.name, description: puzzle.description, questions: newQuestions, symbolName: puzzle.symbolName, emoji: puzzle.emoji, dailyStyle: puzzle.dailyStyle)
        
        Progress.storeProgress(puzzle: puzzle)
    }
    
    var allQuestionsGuessed: Bool {
        var output = true
        for question in puzzle.questions {
            if !question.guessed {
                output = false
            }
        }
        return output
    }
    
    func onCorrectGuess() {
        successHaptic()
        input = ""
    }
    
    func onIncorrectGuess() {
        failiureHaptic()
    }
    
    func focusTextField() {
        textFieldFocused = true
    }
    
    func onSubmitGuess() {
        var correct = false
        for question in puzzle.questions {
            if input.uppercased() == question.container.uppercased() || input.uppercased() == question.insert.uppercased() {
                if !question.guessed {
                    question.guessed = true
                    correct = true
                }
            }
        }
        if correct {
            onCorrectGuess()
        }
        else if input != "" {
            onIncorrectGuess()
        }
        
        if allQuestionsGuessed {
            complete()
        }
        
        Progress.storeProgress(puzzle: puzzle)
        Progress.logGuess()
    }
    
    func successHaptic() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    func failiureHaptic() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
    }
    
    var body: some View {
        
        Group {
            
            // Daily-style version
            
            if playMode.showTopBar {
                VStack {
                    TopBarView(title: title, namespace: namespace, backAction: backAction, menuActions: menuActions)
                    
                    ForEach($puzzle.questions) { $question in
                        Button(action: {if !question.guessed{focusTextField()}}) {
                            QuestionView(category: category, question: question, guessed: question.guessed)
                                .scaleInAfter(offset: question.id)
                        }
                    }
                    
                    Group {
                        if !Progress.hardModeOn {
                            HStack {
                                Text("The category \(puzzle.completed ? "was" : "is")")
                                Image(systemName: puzzle.symbolName)
                                Text(puzzle.name)
                            }
//                            Text("The category \(puzzle.completed ? "was" : "is") \(puzzle.emoji) ") + Text(puzzle.name)
                        }
                        else {
                            Text("The category is hidden in Hard Mode")
                        }
                    }
                    .foregroundColor(.secondary)
                    .padding()
                    .fadeInAfter(offset: Puzzle.dailyPuzzleLength)
                    
                    Spacer()                    
                    
//                    VStack(spacing: 0) {
//                        Divider()
//                        HStack {
//                            TextField("Enter a guess...", text: $input)
//                                .padding(.horizontal)
//                                .padding(.vertical, 7)
//                                .background(
//                                    RoundedRectangle(cornerRadius: 9)
//                                        .foregroundColor(Color(UIColor.systemGroupedBackground))
//                                )
//                                .keyboardType(.alphabet)
//                                .autocorrectionDisabled(true)
//                                .padding()
//                                .onSubmit{onSubmitGuess()}
//                                .focused($textFieldFocused)
//                        }
//                        .background(Color(UIColor.secondarySystemGroupedBackground))
//                    }
                }
                .background(Color(UIColor.systemGroupedBackground)
                    .edgesIgnoringSafeArea(.all))
                .navigationBarHidden(true)
            }
            
            // Categories-style version
            
            else {
                ScrollView {
                    
                    HStack {
                        ProgressView("\(puzzle.totalGuessed) / \(puzzle.questions.count) Complete", value: Double(puzzle.totalGuessed), total: Double(puzzle.questions.count))                        
                    }
                    .foregroundColor(.secondary)
                    .padding()

                    VStack {
                        ForEach($puzzle.questions) { $question in
                            Button(action: {if !question.guessed{focusTextField()}}) {
                                QuestionView(category: category, question: question, guessed: question.guessed)
                            }
                            .padding(.vertical, 3)
                        }
                    }
                    .padding(.bottom, 100)
                    
                    Spacer()
                }
                .background(Color(UIColor.systemGroupedBackground)
                    .edgesIgnoringSafeArea(.all))
                .navigationTitle(title)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        PuzzleOptionsButton(menuActions: menuActions)
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
            }
        }
        
        // Text field
        
        .overlay {
            VStack(spacing: 0) {
                Spacer()
                    Divider()
                    HStack {
                        TextField("Enter a guess...", text: $input)
                            .padding(.horizontal)
                            .padding(.vertical, 7)
                            .background(
                                RoundedRectangle(cornerRadius: 9)
                                    .foregroundColor(Color(UIColor.systemGroupedBackground))
                            )
                            .keyboardType(.alphabet)
                            .autocorrectionDisabled(true)
                            .padding()
                            .onSubmit{onSubmitGuess()}
                            .focused($textFieldFocused)
                    }
                    .background(Color(UIColor.secondarySystemGroupedBackground))

            }
            .opacity(!allQuestionsGuessed && (textFieldFocused || input != "" || playMode.showTopBar) ? 1 : 0)
        }
        .sheet(isPresented: $showingInstructions) {
            InstructionsView()
                .accentColor(playMode.color)
        }
        .sheet(isPresented: $showingYesterdaysAnswers) {
            YesterdayAnswersView()
                .accentColor(playMode.color)
        }
        .alert("Reset this puzzle?", isPresented: $showingResetWarning) {
            Button("Reset", role: .destructive) { showingResetWarning.toggle(); resetProgress() }
        } message: {
            Text("Other puzzles will not be affected.")
        }
    }
}

struct PuzzleView_Previews: PreviewProvider {
    @Namespace static var namespace
    static var previews: some View {
        NavigationView {
            PuzzleView(namespace: namespace, playMode: PlayMode.dailyPuzzle, backAction: {}, complete: {}, puzzle: Puzzle.dailyPuzzle)
        }
    }
}


//    .overlay {
//        VStack(spacing: 0) {
//            Spacer()
//            if textField2Focused {
//                Divider()
//                HStack {
//                    TextField("Enter a guess...", text: $input)
//                        .padding(.horizontal)
//                        .padding(.vertical, 7)
//                        .background(
//                            RoundedRectangle(cornerRadius: 9)
//                                .foregroundColor(Color(UIColor.systemGroupedBackground))
//                        )
//                        .keyboardType(.alphabet)
//                        .autocorrectionDisabled(true)
//                        .padding()
//                        .onSubmit{onSubmitGuess()}
//                        .focused($textField2Focused)
//                }
//                .background(Color(UIColor.secondarySystemGroupedBackground))
////                            .transition(.move(edge: .bottom).combined(with: .opacity))
//            }
//        }
//    }
