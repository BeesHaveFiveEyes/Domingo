
import Foundation

extension Array {
    
    // Shuffle the array according to the supplied seed
    // (Shuffling a given array with a given seed will always yield the same result)
    public func shuffledBySeed(_ seed: Int) -> [Self.Element] {
        var seededGenerator = SeededRandomNumberGenerator(seed: seed)
        return self.shuffled(using: &seededGenerator)
    }
    
    // Choose a random element according to the supplied seed
    // (Choosing a random element from a given array with a given seed will always yield the same element)
    public func randomElementBySeed(_ seed: Int) -> Self.Element? {
        var seededGenerator = SeededRandomNumberGenerator(seed: seed)
        if  self.count > 0 {
            return self.randomElement(using: &seededGenerator)
        }
        else {
            return nil
        }
    }
}
