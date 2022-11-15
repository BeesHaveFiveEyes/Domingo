//
//  CategoriesView.swift
//  Wordout
//
//  Created by Alasdair Casperd on 03/11/2022.
//

import SwiftUI

struct CategoriesView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    func back() {
        presentationMode.wrappedValue.dismiss()
    }
    
    var body: some View {
//        Form {
//            Section(header: HeaderView()) {
//                ForEach(categories) { category in
//                    Section {
//                        NavigationLink {
//                            CategoryView(category: category)
//                        } label: {
//                            HStack {
//                                Image(systemName: category.symbolName)
//                                    .font(.title)
//                                    .frame(width: 30, height: 30)
//                                    .padding()
//                                    .padding(.trailing, 5)
//                                    .foregroundColor(.accentColor)
////                                Text(category.emoji)
////                                    .font(.largeTitle)
////                                    .frame(width: 35)
////                                    .padding(.trailing, 8)
//                                HStack {
//                                    Text(category.name)
//                                        .fontWeight(.semibold)
//                                    Spacer()
//                                    Text(category.questions.count == 0 ? "Coming Soon" : "\(category.puzzle.loadingFromProgress().totalGuessed) / \(category.questions.count)")
//                                        .foregroundColor(.secondary)
//                                }
//                                Spacer()
//                            }
//                        }
//                        .disabled(category.questions.count == 0)
//                    }
//                }
//            }
//        }
        GeometryReader { geometry in
            ScrollView {
                Text("Browse the categories below to attempt any of the puzzles from our enormous catalogue.")
                    .padding(.horizontal)
                    .padding(.top)
                CategoryGridView(categories: Category.freeCategories)
                Text("Browse the categories below to attempt any of the puzzles from our enormous catalogue.")
                    .padding(.horizontal)
                    .padding(.top)
                CategoryGridView(categories: Category.paidCategories)
                Spacer()
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
            CategoriesView()
                .accentColor(WordoutApp.themeColor)
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
    
    var categories: [Category]
    let columns = [GridItem(.adaptive(minimum: 150), spacing: 14)]
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 14) {
            ForEach(categories) { category in
                NavigationLink {
                    CategoryView(category: category)
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
                            Text(category.questions.count == 0 ? "Coming Soon" : "\(category.puzzle.loadingFromProgress().totalGuessed) / \(category.questions.count)")
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding()
                }
                .background(RoundedRectangle(cornerRadius: 14).foregroundColor(Color(UIColor.secondarySystemGroupedBackground)))
                .disabled(category.questions.count == 0)
            }
        }
        .padding()
    }
}
