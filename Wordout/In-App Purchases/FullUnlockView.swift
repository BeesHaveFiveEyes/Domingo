
import StoreKit
import SwiftUI

// A view advertising the full version of the app

struct FullUnlockView: View {
    
    @EnvironmentObject var unlockManager: UnlockManager
    
    // The SKProduct corresponding to the in app purchase
    let product: SKProduct
    
    // The total number of questions in the app, rounded down to the nearest 10
    private var totalQuestionsRoundedDown: Int {
        return 10 * Int(round(Double(Category.totalQuestionsCount - 1) / 10.0))
    }
    
    // The total number of archived puzzles currently available in the app
    private var totalArchivedPuzzles: Int {
        return Date().seed - Date.referenceDate.seed
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("The daily puzzle and the first four categories are free, but to support development I ask for a small contribution to unlock the rest of the categories and the archived puzzles.")
                                
                VStack(alignment: .leading, spacing: 30) {
                    FullUnlockRowView(symbolName: nil, description: "Over \(totalQuestionsRoundedDown) words to crack")
                    // TODO: Correct symbol
                    FullUnlockRowView(symbolName: "questionmark", description: "\(Category.categories.count) Categories")
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
