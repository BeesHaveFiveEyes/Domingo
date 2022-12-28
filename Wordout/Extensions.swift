//
//  Extensions.swift
//  Wordout
//
//  Created by Alasdair Casperd on 04/11/2022.
//

import SwiftUI
import StoreKit

extension URL {
    var typeIdentifier: String? { (try? resourceValues(forKeys: [.typeIdentifierKey]))?.typeIdentifier }
    var isTxt: Bool { typeIdentifier == "public.txt" }
    var localizedName: String? { (try? resourceValues(forKeys: [.localizedNameKey]))?.localizedName }
    var hasHiddenExtension: Bool {
        get { (try? resourceValues(forKeys: [.hasHiddenExtensionKey]))?.hasHiddenExtension == true }
        set {
            var resourceValues = URLResourceValues()
            resourceValues.hasHiddenExtension = newValue
            try? setResourceValues(resourceValues)
        }
    }
}

extension Bundle {
    
    func decodeCategories(_ indexFile: String) -> [Category] {
        
        guard let url = self.url(forResource: indexFile, withExtension: nil) else {
            fatalError("Failed to locate \(indexFile) in bundle.")
        }

        guard let text = try? String(contentsOf: url) else {
            fatalError("Failed to load \(indexFile) from bundle.")
        }
        
        let fileNames = text.components(separatedBy: "\n").filter({ $0.count > 0 })
        
        var output = [Category]()
        
        for fileName in fileNames {
            
            let fileNameWithExtension = fileName + ".txt"
            
            guard let url = self.url(forResource: fileNameWithExtension, withExtension: nil) else {
                fatalError("Failed to locate \(fileName) in bundle.")
            }

            guard let text = try? String(contentsOf: url) else {
                fatalError("Failed to load \(fileName) from bundle.")
            }
                        
            output.append(Bundle.readCategoryFromTextWithTwoWords(text, fileName: fileName))
        }
        
        return output
    }
    
    static func readCategoryFromTextWithTwoWords(_ text: String, fileName: String = "a file") -> Category {
        let lines = text.components(separatedBy: "\n").filter({ $0.count > 0 })
        
        var name = ""
        var symbolName = ""
        var emoji = ""
        var questions = [Question]()
        
        var i = 0
        
        for line in lines {
            if i == 0 {
                name = line
                i += 1
            }
            else if i == 1 {
                emoji = line
                i += 1
            }
            else if i == 2 {
                symbolName = line
                i += 1
            }
            else if i == 3 {
                // Store batch information
                i += 1
            }
            else {
                let words = line.components(separatedBy: " ").filter({ $0.count > 0 })
                if words.count == 2 {
                    questions.append(Question(id: i-3, container: words[0], insert: words[1]))
                }
                else {
                    fatalError("Index error on line \"\(line)\" while loading \(fileName) from bundle.")
                }
                i += 1
            }
        }
        
        return Category(name: name, description: nil, questions: questions, symbolName: symbolName, emoji: emoji)
    }
    
    static func readCategoryQuestionsFromTextWithCapitalisation(_ text: String, fileName: String = "a file") -> Category? {
        let lines = text.components(separatedBy: "\n").filter({ $0.count > 0 })

        var questions = [Question]()
        
        var i = 0
        
        for line in lines {
            let container = line.lowercased()
            let insert = line.filter({"ABCDEFGHIJKLMNOPQRSTUVWXYZ".contains($0)}).lowercased()
            let components = container.components(separatedBy: insert).filter({ $0.count > 0 })
            if components.count == 1 {
                if !(container == components[0] + insert || container == insert + components[0]) {
                    return nil
                }
            }
            else if components.count == 2 {
                if !(container == components[0] + insert + components[1]) {
                    return nil
                }
            }
            else {
                return nil
            }
            if container.count > 0 && insert.count > 0 {
                questions.append(Question(id: i+1, container: container, insert: insert))
            }
            else {
                return nil
            }
            i += 1
        }
        
        return Category(name: "", description: nil, questions: questions, symbolName: "", emoji: "")
    }
}

extension Calendar {
    
    // Returns the number of days between two dates, not including the first
    
    func countDaysBetween(start: Date, end: Date) -> Int {
        let startDate = startOfDay(for: start)
        let endDate = startOfDay(for: end)
        let days = dateComponents([.day], from: startDate, to: endDate)
        return days.day!
    }
}

extension Date {
    
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
    
    public var seed: Int {
        let calendar = Calendar(identifier: .gregorian)
        return calendar.countDaysBetween(start: Date.referenceDate, end: self)
    }
    
    static func dateForSeed(_ seed: Int) -> Date {
        return Date.referenceDate.addingTimeInterval(60*60*24*Double(seed))
    }
}

extension UIFont {
    static func textStyleSize(_ style: UIFont.TextStyle) -> CGFloat {
        UIFont.preferredFont(forTextStyle: style).pointSize
    }
}

extension SKProduct {
    var localizedPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = priceLocale
        return formatter.string(from: price)!
    }
}

extension UIScreen{
   static let screenWidth = UIScreen.main.bounds.size.width
   static let screenHeight = UIScreen.main.bounds.size.height
   static let screenSize = UIScreen.main.bounds.size
}

extension View {
    func snapshot() -> UIImage {
        let controller = UIHostingController(rootView: self)
        let view = controller.view

        let targetSize = controller.view.intrinsicContentSize
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .clear

        let renderer = UIGraphicsImageRenderer(size: targetSize)

        return renderer.image { _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
}
