
import SwiftUI

// A view containing a button which links to a CategoryView for a particular category

struct CategoryGridButton: View {
    
    @EnvironmentObject var mainMenuModel: MainMenuModel
    @State private var showingCategoryView = false
    
    // The displayed category
    var category: Category
    
    // Is this category unlocked?
    var unlocked: Bool
    
    var body: some View {
        Button {
            if unlocked {
                showingCategoryView = true
            }
            else {
                mainMenuModel.showInAppPurchaseView()
            }
        } label: {
            CategoryCardView(category: category, unlocked: unlocked)
        }
        .background {
            NavigationLink(isActive: $showingCategoryView) {
                CategoryView()
                    .environmentObject(CategoryViewModel(category: category))
            } label: {
                EmptyView()
            }
        }
    }
}
