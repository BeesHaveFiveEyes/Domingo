//
//  FullUnlockView.swift
//  Wordout
//
//  Created by Alasdair Casperd on 17/11/2022.
//

import StoreKit
import SwiftUI

struct FullUnlockView: View {
    
    @EnvironmentObject var unlockManager: UnlockManager
    
    let product: SKProduct

    private var totalCategories: Int {
        return Category.premadeCategories.filter({$0.questions.count > 0}).count
    }
    
    private var totalQuestions: Int {
        var i = 0
        for category in Category.premadeCategories {
            i += category.questions.count
        }
        return i
    }
    
    private var totalQuestionsRoundedDown: Int {
        return 10 * Int(round(Double(totalQuestions - 1) / 10.0))
    }
    
    private var totalArchivedPuzzles: Int {
        return Date().seed - Date.referenceDate.seed
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("The daily puzzle and the first four categories are free, but to support development I ask for a small contribution to unlock the rest of the categories and the archived puzzles.")
                                
                VStack(alignment: .leading, spacing: 30) {
                    FullUnlockRowView(symbolName: nil, description: "Over \(totalQuestionsRoundedDown) words to crack")
                    FullUnlockRowView(symbolName: PlayMode.categories.symbolName, description: "\(totalCategories) Categories")
                    FullUnlockRowView(symbolName: "calendar", description: "\(totalArchivedPuzzles) Archived Puzzles and counting")
                    FullUnlockRowView(symbolName: "gift.fill", description: "Any future puzzles at no extra cost")
                }
                .font(.headline)
                Spacer()
            }
            .padding()
        }
        .overlay {
            VStack {
                Spacer()
                Button(action: unlock) {
                    HStack {
                        Spacer()
                        Text("Purchase Full Unlock for \(product.localizedPrice)")
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 14)
                            .foregroundColor(.accentColor)
                    }
                }

                HStack {
                    Spacer()
                    Button("Restore Purchases", action: unlockManager.restore)
                    Spacer()
                }
                .padding()
            }
            .padding()
        }
    }

    func unlock() {
        unlockManager.buy(product: product)
    }
}

struct FullUnlockRowView: View {
    var symbolName: String?
    var description: String
    var body: some View {
        HStack {
            Group{
                if symbolName == nil {
                    Text(WordoutApp.placeholder)
                        .font(.largeTitle)
                }
                else {
                    Image(systemName: symbolName!)
                }
            }
            .frame(width: 50, height: 50)
            .padding(.trailing, 5)
            .foregroundColor(.accentColor)
            .font(.title2)
            Text(description)
            Spacer()
            Image(systemName: "checkmark")
                .foregroundColor(.accentColor)
                .padding()
        }
    }
}
