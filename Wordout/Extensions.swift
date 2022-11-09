//
//  Extensions.swift
//  Wordout
//
//  Created by Alasdair Casperd on 04/11/2022.
//

import Foundation

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
            
            let lines = text.components(separatedBy: "\n").filter({ $0.count > 0 })
            
            var name = ""
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
                    // Store batch information
                    i += 1
                }
                else {
                    let words = line.components(separatedBy: " ").filter({ $0.count > 0 })                    
                    if words.count == 2 {
                        questions.append(Question(id: i-2, container: words[0], insert: words[1]))
                    }
                    else {
                        fatalError("Index error on line \"\(line)\" while loading \(fileName) from bundle.")
                    }
                    i += 1
                }
            }
                        
            output.append(Category(name: name, description: nil, questions: questions, emoji: emoji))
        }
        
        return output
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

