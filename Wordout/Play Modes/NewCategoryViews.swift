//
//  NewCategoryFirstView.swift
//  Wordout
//
//  Created by Alasdair Casperd on 10/11/2022.
//

import SwiftUI

struct NewCategoryView: View {
    
    @State private var name = ""
    @State private var emoji = ""
    @State private var author = ""
    @State private var questionsText = ""
    
    @State private var showingAlert = false
    @State private var showingPreviewView = false
    
    @FocusState private var editingNameText: Bool
    @FocusState private var editingEmojiText: Bool
    @FocusState private var editingAuthorText: Bool
    @FocusState private var editingEditorText: Bool
    
    @State private var alertTitle: String = ""
    @State private var alertMessage: String = ""
    
    var dismiss: () -> ()
    
    @State private var category: Category = Category(name: "", description: nil, questions: [Question](), symbolName: "", emoji: "")
    
    func showAlert(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        showingAlert = true
    }

    func next() {
        let newCategory = Bundle.readCategoryQuestionsFromTextWithCapitalisation(questionsText)
        if newCategory == nil {
            showAlert(title: "Invalid Wordlist", message: "The list of words you have entered is not in the correct format.")
        }
        else {
            if newCategory!.questions.count < 3 {
                showAlert(title: "Not Enough Words", message: "Please add at least three words on separate lines.")
            }
            else {
                category = Category(name: name, description: author == "" ? nil : author, questions: newCategory!.questions, symbolName: "", emoji: emoji, custom: true)
                showingPreviewView = true
            }
        }
    }
    
    var body: some View {
        NavigationView {
            Form {
                
                Section(
                    header:
                        Text("First choose a category for your puzzle. Try to choose a category which contains a lot of short words.")
                        .font(.body)
                        .textCase(.none)
                        .padding(.horizontal, -14)
                        .padding(.bottom)
                ) {
                    TextField("Category Name", text: $name)
                        .focused($editingNameText)
                        .icon("tag")
                    TextField("Emoji", text: $emoji)
                        .focused($editingEmojiText)
                        .icon("face.smiling")
                }
                
                Section(
                    header:
                        Text("Next, optionally provide a name or pseudonym. This will be visible to people with whom you choose to share your puzzle via an export code.").font(.body)
                        .textCase(.none)
                        .padding(.horizontal, -14)
                        .padding(.bottom)
                ) {
                    TextField("Author name (optional)", text: $author)
                        .focused($editingAuthorText)
                        .icon("person.crop.circle")
                }
                
                Section(
                    header:
                        VStack(alignment: .leading, spacing: 14) {
                            Text("Now write the individual questions for your puzzle. Enter each word on a separate line with its subword capitalised (e.g. sTREEtlight)")
                            Button("Struggling to think of questions?") {}
                            .padding(.top)
                            NavigationLink(destination: NewCategoryPreviewView(dismiss: dismiss, category: category), isActive: $showingPreviewView, label: { EmptyView() })
                        }
                        .font(.body)
                        .textCase(.none)
                        .padding(.horizontal, -14)
                        .padding(.bottom)
                ) {
                    TextEditor(text: $questionsText)
                        .autocapitalization(.none)
                        .autocorrectionDisabled()
                        .keyboardType(.alphabet)
                        .focused($editingEditorText)
                }
            }
            .navigationTitle("New Puzzle")
            .toolbar {
                ToolbarItem(placement: .keyboard) {
                    Button("Done") { editingEditorText = false; editingNameText = false; editingAuthorText = false; editingEmojiText = false }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Next", action: next)
                        .disabled(name == "" || questionsText == "" || emoji == "")
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel", action: dismiss)
                }
            }
            .alert(alertTitle, isPresented: $showingAlert) {
                Button("Ok", role: .cancel) {showingAlert = false}
            } message: {
                Text(alertMessage)
            }
        }
    }
}

struct NewCategoryPreviewView: View {
    
    var dismiss: () -> ()
    
    var category: Category
    
    func create() {
        dismiss()
    }
    
    var body: some View {

        Form {
            Section(
                header:
                    Text("Check the preview below carefully. If it matches what you were expecting, press done to finish.")
                    .font(.body)
                    .textCase(.none)
                    .padding(.horizontal, -14)
                    .padding(.bottom)
            ) {
                ForEach(category.questions) { question in
                    HStack {
                        Text(question.clue)
                        Spacer()
                        Text(question.insert.capitalized)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .navigationTitle("Puzzle Preview")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Done", action: create)
            }
        }
    }
}

struct NewCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        NewCategoryView(dismiss: {})
    }
}
