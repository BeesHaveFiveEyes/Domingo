
import SwiftUI

// A view showing a small card representing one of the game's categories

struct CategoryCardView: View {
    
    // The displayed category
    var category: Category
    
    // Is this category unlocked?
    var unlocked: Bool
    
    // A subtitle to display under the category name
    var subtitle: String {
        let n = category.questions.count
        let m = DomingoEngine.loadCategoryPuzzle(category).totalQuestionsGuessed
        
        if n == 0 {
            return "Coming Soon"
        }
        else {
            return "\(m) / \(n)"
        }
    }
    
    var body: some View {
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
                    if !unlocked {
                        Image(systemName: "lock.fill")
                    }
                    Text(subtitle)
                }
                .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 14).foregroundColor(Color(UIColor.secondarySystemGroupedBackground)))
    }
}
