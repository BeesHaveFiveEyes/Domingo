//
//  StoredInteger.swift
//  Wordout
//
//  Created by Alasdair Casperd on 26/11/2022.
//

import Foundation

struct StoredInteger {
    
    public let key: String
    
    public var value: Int {
        return UserDefaults.standard.integer(forKey: key)
    }
    
    public func replace(with integer: Int) {
        UserDefaults.standard.set(integer, forKey: key)
    }
    
    public func increment(by step: Int = 1) {
        UserDefaults.standard.set(value + step, forKey: key)
    }
}
