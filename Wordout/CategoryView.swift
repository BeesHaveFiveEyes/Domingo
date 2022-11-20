//
//  CategoryView.swift
//  Wordout
//
//  Created by Alasdair Casperd on 03/11/2022.
//

import SwiftUI

struct CategoryView: View {
    
    var category: Category

    enum CategoryViewState {        
        case inProgress
    }
    
    @Environment(\.presentationMode) var presentationMode
    
    @Namespace var namespace
    
    @State private var state: CategoryViewState = .inProgress
    
    func quit() {
        presentationMode.wrappedValue.dismiss()
    }
    
    var body: some View {
        PuzzleView(namespace: namespace, playMode: .categories, backAction: quit, complete: {}, category: category, puzzle: category.puzzle.loadingFromCategoryProgress())
    }
}

struct CategoryView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryView(category: Category.example)
    }
}
