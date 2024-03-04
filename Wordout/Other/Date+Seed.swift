
import Foundation

extension Date {
    
    // The reference date used for 'puzzle 0' with seed 0
    public static var referenceDate: Date {
        
        let calendar = Calendar(identifier: .gregorian)
        
        var referenceDateComponents = DateComponents()
        
        referenceDateComponents.year = 2022
        referenceDateComponents.month = 10
        referenceDateComponents.day = 25
        referenceDateComponents.timeZone = TimeZone(abbreviation: "GMT")
        referenceDateComponents.hour = 12
        referenceDateComponents.minute = 0

        return calendar.date(from: referenceDateComponents)!
    }
    
    // The seed corresponding to the date for daily puzzle generation
    public var seed: Int {
        let calendar = Calendar(identifier: .gregorian)
        return calendar.countDaysBetween(start: Date.referenceDate, end: self)
    }
    
    // The date corresponding to a given seed
    static func dateForSeed(_ seed: Int) -> Date {
        return Date.referenceDate.addingTimeInterval(60*60*24*Double(seed))
    }
}
