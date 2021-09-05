//
//  UserDefault.swift
//  mylost
//
//  Created by Nato Egnatashvili on 05.09.21.
//

import Foundation

class UserDefaultManager {
    
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
