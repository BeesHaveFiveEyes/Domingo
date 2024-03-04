
import SwiftUI

// A view displaying all of the game's categories

struct CategoriesView: View {
    
    @EnvironmentObject var unlockManager: UnlockManager
    
    let columns = [GridItem(.adaptive(minimum: 150), spacing: 14)]
    
    var body: some View {
        
        ScrollView {
            VStack(alignment: .leading) {
                
                // Introduction
                
                Text("Browse the categories below to attempt any of the puzzles from \(DomingoEngine.appName)'s enormous catalogue.")
                    .padding(.horizontal)
                    .padding(.top)
                
                // Grid
                
                LazyVGrid(columns: columns, spacing: 14) {
                    ForEach(Category.freeCategories) { category in
                        CategoryGridButton(category: category, unlocked: true)
                    }
                    ForEach(Category.paidCategories) { category in
                        CategoryGridButton(category: category, unlocked: unlockManager.fullVersionUnlocked)
                    }
                }
                .padding(.horizontal)
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
                .environmentObject(UnlockManager(previewValue: false))
                .environmentObject(MainMenuModel())
        }
    }
}
