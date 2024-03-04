
import Foundation

// A seeded random number generator
// Used for generating the daily puzzles

struct SeededRandomNumberGenerator: RandomNumberGenerator {
    
    init(seed: Int) {
        srand48(seed)
    }
    
    func next() -> UInt64 {
        return UInt64(drand48() * Double(UInt64.max))
    }
}
