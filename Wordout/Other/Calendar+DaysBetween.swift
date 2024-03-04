
import Foundation

extension Calendar {
    
    // Returns the number of days between two dates, not including the first
    func countDaysBetween(start: Date, end: Date) -> Int {
        let startDate = startOfDay(for: start)
        let endDate = startOfDay(for: end)
        let days = dateComponents([.day], from: startDate, to: endDate)
        return days.day!
    }
}
