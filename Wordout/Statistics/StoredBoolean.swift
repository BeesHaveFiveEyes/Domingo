
import Foundation

// A helper class used to simplify the process of storing boolean values with UserDefaults

struct StoredBoolean {
    
    public let key: String
    
    public var value: Bool {
        return UserDefaults.standard.bool(forKey: key)
    }
    
    public func replace(with boolean: Bool) {
        UserDefaults.standard.set(boolean, forKey: key)
    }
    
    public func toggle() {
        UserDefaults.standard.set(!value, forKey: key)
    }
}
