//
//  PickerData.swift
//  mylost
//
//  Created by Nato Egnatashvili on 05.09.21.
//

import Foundation

protocol PickerDataManager {
    var pickerDictionary: [PickerDataManagerImpl.PickerType: [String]] {get set}
    func getIntType(with type: PickerDataManagerImpl.PickerType, chooseValue: String) -> Int?
    func addPickerTypeToDict(type: PickerDataManagerImpl.PickerType, data: [String]) 
}

class PickerDataManagerImpl: PickerDataManager {
    var pickerDictionary: [PickerType: [String]] = [.age: ["0", "0"], .bloodType: ["a"], .city: ["Tbilisi"], .relativeType: ["დედა"], .sexType: ["მდედრობითი"]]
    
    func addPickerTypeToDict(type: PickerType, data: [String]) {
        pickerDictionary[type] = data
        print(pickerDictionary)
    }
    
    enum PickerType {
        case bloodType
        case relativeType
        case sexType
        case city
        case age
        
        var data: [String] {
            switch self {
            case .bloodType:
                return ["a", "b", "ab"]
            case .relativeType:
                return ["დედა", "მამა", "ძმა", "და", "მეგობარი"]
            case .sexType:
                return ["მდედრობითი", "მამრობითი"]
            case .city:
                return ["Tbilisi", "Batumi", "Kutaisi", "Gori", "Other"]
            case .age:
                return getAgeArray()
            }
        }
        
        var vectorData: [[String]] {
            switch self {
            case .bloodType:
                return [data]
            case .relativeType:
                return [data]
            case .sexType:
                return [data]
            case .city:
                return [data]
            case .age:
                return [data, data]
            }
        }
        
        var title: String {
            switch self {
            case .bloodType:
                return "სისხლის ტიპი"
            case .relativeType:
                return "ნათესაობის ტიპი"
            case .sexType:
                return "სქესი"
            case .city:
                return "ქალაქი"
            case .age:
                return "ასაკი"
            }
        }
        
        func getAgeArray() -> [String] {
            var arr: [String] = []
            for i in 0...100 {
                arr.append(i.description)
            }
            return arr
        }
    }
    
    func getIntType(with type: PickerType, chooseValue: String) -> Int? {
        if let index = type.data.firstIndex(where: {$0 == chooseValue}) {
            return index + 1
        }
        return nil
    }
    
}
