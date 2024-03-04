
import Foundation

extension Bundle {
    
    // Load in all puzzle categories from the bundle
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
                        
            output.append(Bundle.decodeCategory(text, fileName: fileName))
        }
        
        return output
    }
    
    // Load in a category from the supplied text
    static func decodeCategory(_ text: String, fileName: String) -> Category {
        
        let lines = text.components(separatedBy: "\n").filter({ $0.count > 0 })
        
        var name = ""
        var symbolName = ""
        var questions = [Question]()
        
        var i = 0
        
        for line in lines {
            if i == 0 {
                name = line
            }
            else if i == 1 {
                // Store emoji
            }
            else if i == 2 {
                symbolName = line
            }
            else if i == 3 {
                // Store batch information
            }
            else {
                let words = line.components(separatedBy: " ").filter({ $0.count > 0 })
                if words.count == 2 {
                    questions.append(Question(container: words[0], insert: words[1]))
                }
                else {
                    fatalError("Index error on line \"\(line)\" (i = \(i)) while loading \(fileName) from bundle.")
                }
            }
            i += 1
        }
        
        return Category(name: name, questions: questions, symbolName: symbolName)
    }
}
