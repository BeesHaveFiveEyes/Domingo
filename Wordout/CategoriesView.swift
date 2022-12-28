//
//  CategoriesView.swift
//  Wordout
//
//  Created by Alasdair Casperd on 03/11/2022.
//

import SwiftUI

struct CategoriesView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var unlockManager: UnlockManager
    
    func back() {
        presentationMode.wrappedValue.dismiss()
    }
    
    func enterCategory(_ category: Category)
    {
        selectedCategory = category
        showingCategoryView = true
    }
    
    @State private var selectedCategory = Category.premadeCategories[0]
    @State private var showingCategoryView = false
    
    var showPurchaseView: () -> ()
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(alignment: .leading) {
                    Text("Browse the categories below to attempt any of the puzzles from \(Domingo.appName)'s enormous catalogue.")
                        .padding(.horizontal)
                        .padding(.top)
                    CategoryGridView(showPurchaseView: showPurchaseView, enterCategory: enterCategory, fullUnlockEnabled: unlockManager.fullVersionUnlocked)
                    Spacer()
                    NavigationLink(isActive: $showingCategoryView) {
                        CategoryView(category: selectedCategory)
                    } label: {
                        EmptyView()
                    }
                    .disabled(selectedCategory.questions.count == 0)
                }
            }
        }
        .navigationTitle("Categories")
        .navigationBarTitleDisplayMode(.large)
        .background(Color(UIColor.systemGroupedBackground)
            .edgesIgnoringSafeArea(.all))
    }
}

struct CategoriesView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CategoriesView(showPurchaseView: {})
                .accentColor(Domingo.themeColor)
        }
    }
}

struct HeaderView: View {
    var body: some View {
        Text("Browse the categories below to attempt any of the puzzles from our enormous catalogue.")
            .textCase(.none)
            .font(.body)
            .padding(.horizontal, -14)
            .padding(.bottom)
    }
}

struct CategoryGridView: View {
    
    var showPurchaseView: () -> ()
    var enterCategory: (Category) -> ()
    let columns = [GridItem(.adaptive(minimum: 150), spacing: 14)]
    
    var fullUnlockEnabled: Bool
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 14) {
            ForEach(Category.freeCategories) { category in
                CategoryGridItem(showPurchaseView: showPurchaseView, enterCategory: enterCategory, category: category, disabled: false)
            }
            ForEach(Category.paidCategories) { category in
                CategoryGridItem(showPurchaseView: showPurchaseView, enterCategory: enterCategory, category: category, disabled: !fullUnlockEnabled)
            }
        }
        .padding(.horizontal)
    }
}

struct CategoryGridItem: View {
    
    var showPurchaseView: () -> ()
    var enterCategory: (Category) -> ()
    
    @State private var showingCategoryView = false
    
    var category: Category
    var disabled: Bool
    
    var subtitle: String {
        let n = category.questions.count
        let m = Progress.loadStoredPuzzle(for: category.puzzle).totalGuessed
        
        if n == 0 {
            return "Coming Soon"
        }        
        else {
            return "\(m) / \(n)"
        }
    }
    
    var body: some View {
        Button {
            if disabled {
                showPurchaseView()
            } else {
                enterCategory(category)
            }
        } label: {
            VStack(alignment: .leading) {
                Spacer()
                HStack {
                    Image(systemName: category.symbolName)
                        .font(.title)
                        .frame(width: 50, height: 50, alignment: .leading)
                        .foregroundColor(.accentColor)
                    Spacer()
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text(category.name)
                        .foregroundColor(.primary)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.leading)
                    HStack(spacing: 4) {
                        if disabled {
                            Image(systemName: "lock.fill")
                        }
                        Text(subtitle)
                    }
                    .foregroundColor(.secondary)
                }
                NavigationLink(isActive: $showingCategoryView) {
                    CategoryView(category: category)
                } label: {
                    EmptyView()
                }
                .disabled(category.questions.count == 0)
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 14).foregroundColor(Color(UIColor.secondarySystemGroupedBackground)))
        }
    }
}
