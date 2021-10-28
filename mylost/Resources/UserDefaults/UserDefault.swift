//
//  UserDefault.swift
//  mylost
//
//  Created by Nato Egnatashvili on 05.09.21.
//

import Foundation

protocol UserDefaultManager {
    func saveKeyName(key: String, value: Any)
    func getValue(key: String) -> Any?
    func removeValue(key: String)
}

class UserDefaultManagerImpl: UserDefaultManager {
    
    private let defaults = UserDefaults.standard
    
    func saveKeyName(key: String, value: Any) {
        defaults.setValue(value, forKey: key)
    }
    
    func getValue(key: String) -> Any? {
        defaults.value(forKey: key)
    }
    
    func removeValue(key: String) {
        defaults.removeObject(forKey: key)
    }
}
