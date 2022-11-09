//
//  CategoriesView.swift
//  Wordout
//
//  Created by Alasdair Casperd on 03/11/2022.
//

import SwiftUI

struct CategoriesView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var categories: [Category] = Category.premadeCategories
    
    func back() {
        presentationMode.wrappedValue.dismiss()
    }
    
    let columns = [GridItem(.adaptive(minimum: 120))]
    
    var body: some View {
        Form {
            Section(header: HeaderView()) {
                ForEach(categories) { category in
                    Section {
                        NavigationLink {
                            CategoryView(category: category)
                        } label: {
                            HStack {
                                Text(category.emoji)
                                    .font(.largeTitle)
                                    .frame(width: 35)
                                    .padding(.trailing, 8)
                                HStack {
                                    Text(category.name)
                                        .fontWeight(.semibold)
                                    Spacer()
                                    Text(category.questions.count == 0 ? "Coming Soon" : "\(category.puzzle.totalGuessed) / \(category.questions.count)")
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                            }
                        }
                        .disabled(category.questions.count == 0)
                    }
                }
            }
        }
//        GeometryReader { geometry in
//            ScrollView {
//                LazyVGrid(columns: columns, spacing: 14) {
//                    ForEach(categories) { category in
//                        NavigationLink {
//                            CategoryView(category: category)
//                        } label: {
//                            VStack {
//                                Text(category.emoji)
//                                    .font(.largeTitle)
//                                    .frame(width: 35)
//                                    .padding(.trailing, 8)
//                                VStack(alignment: .leading) {
//                                    Text(category.name)
//                                    Text(category.questions.count == 0 ? "Coming Soon" : "\(category.questions.count) Puzzles")
//                                        .foregroundColor(.secondary)
//                                }
//                                Spacer()
//                            }
//                            .padding()
//                        }
//                        .frame(height: 100)
//                        .background(RoundedRectangle(cornerRadius: 14).foregroundColor(Color(UIColor.secondarySystemGroupedBackground)))
//                        .disabled(category.questions.count == 0)
//                        .padding(.leading, 14)
//                    }
//                }
//                .padding(.trailing, 14)
//                .padding(.vertical, 14)
//                Spacer()
//            }
//        }
//        .toolbar {
//            ToolbarItem(placement: .navigationBarTrailing) {
//                Button(action: {}) {
//                    Image(systemName: "plus")
//                }
//            }
//        }
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
