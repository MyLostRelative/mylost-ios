//
//  UserDefault.swift
//  mylost
//
//  Created by Nato Egnatashvili on 05.09.21.
//

import Foundation

public protocol UserDefaultManager {
    func saveKeyName(key: String, value: Any)
    func getValue(key: String) -> Any?
    func removeValue(key: String)
}

public class UserDefaultManagerImpl: UserDefaultManager {
    public init() {}
    private let defaults = UserDefaults.standard
    
    public func saveKeyName(key: String, value: Any) {
        defaults.setValue(value, forKey: key)
    }
    
    public func getValue(key: String) -> Any? {
        defaults.value(forKey: key)
    }
    
    public func removeValue(key: String) {
        defaults.removeObject(forKey: key)
    }
}
