
import SwiftUI

// A single question from a puzzle or category in the game, such as 'ex ? ble'

struct Question: Identifiable, Equatable, Hashable {
    
    // ----------------
    // Static Functions
    // ----------------
    
    // Equatable conformance
    static func == (lhs: Question, rhs: Question) -> Bool {
        return lhs.id == rhs.id
    }
    
    // -----------------
    // Stored Properties
    // -----------------
    
    // A unique identifier for the question
    let id = UUID()
    
    // The full-word solution to the question
    let container: String
    
    // The 'inside-word' required to solve the question
    let insert: String
    
    // -------------------
    // Computed Properties
    // -------------------
    
    // A textual representation of the question with the coda placeholder obscuring the answer
    var clue: String {
        return left.capitalized + " \(DomingoEngine.placeholder) " + right
    }
    
    // The 'inside-word' captialised as appropriate, i.e if it begins the word
    var formattedInsert: String {
        return left == "" ? insert.lowercased().capitalized : insert.lowercased()
    }
    
    // The portion of the container word preceding the insert
    var left: String {
        let components = (" " + container + " ").components(separatedBy: insert).filter({ $0.count > 0 })
        if components.count < 2 {
            fatalError("Invalid question: Container \'\(container)\' does not contain \"\(insert)\"")
        }
        else {
            let l = components[0].filter({!($0 == " ")})
            return l
        }
    }
    
    // The portion of the container word following the insert
    var right: String {
        let components = (" " + container + " ").components(separatedBy: insert).filter({ $0.count > 0 })
        if components.count < 2 {
            fatalError("Invalid question: Container \'\(container)\' does not contain \"\(insert)\"")
        }
        else {
            let r = components[1].filter({!($0 == " ")})
            return r
        }
    }
    
    // The full solution to the questions with hyphens to emphasise the inserted word
    var explicitAnswer: String {
        return left + "-" + insert + "-" + right
    }
    
    // ------------
    // Initialisers
    // ------------
    
    init(container: String, insert: String) {
        self.container = container
        self.insert = insert
    }
}
