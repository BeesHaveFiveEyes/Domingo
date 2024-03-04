
import SwiftUI

// A row view displaying a statistic about the user's puzzle progress

struct StatisticRowView: View {
    
    var name: String
    var detail: String
    var symbolName: String
    
    var body: some View {
        HStack {
            Text(name)
            Spacer()
            Text(detail)
                .foregroundColor(.secondary)
        }
        .icon(symbolName)
    }
}

#Preview {
    Form {
        StatisticRowView(name: "Current Streak", detail: "4 days", symbolName: "flame")
    }
}
