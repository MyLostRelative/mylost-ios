//
//  PickerData.swift
//  mylost
//
//  Created by Nato Egnatashvili on 05.09.21.
//

import Foundation

protocol PickerDataManager {
    func getIntType(with type: PickerDataManagerImpl.PickerType, chooseValue: String) -> Int?
    func addPickerTypeToDict(type: PickerDataManagerImpl.PickerType, data: [String])
    var statementSearchEntity: StatementSearchEntity { get }
}

class PickerDataManagerImpl: PickerDataManager {
    var pickerDictionary: [PickerType: [String]] = [.age: ["არცერთი", "არცერთი"],
                                                    .bloodType: ["არცერთი"],
                                                    .city: ["არცერთი"],
                                                    .relativeType: ["არცერთი"],
                                                    .sexType: ["არცერთი"]]
    
    func addPickerTypeToDict(type: PickerType, data: [String]) {
        pickerDictionary[type] = data
        print(pickerDictionary)
    }
    
    func getIndex(str: String , data: [String]) -> Int {
        return data.firstIndex(where: {$0 == str}) ?? 0
    }
    
    var statementSearchEntity: StatementSearchEntity {
        let city = getIndex(str: pickerDictionary[.city]?[0] ?? "", data: PickerType.city.data)
        let bloodType = getIndex(str: pickerDictionary[.bloodType]?[0] ?? "", data: PickerType.bloodType.data)
        let relativeType = getIndex(str: pickerDictionary[.relativeType]?[0] ?? "", data: PickerType.relativeType.data)
        let sexType = getIndex(str: pickerDictionary[.sexType]?[0] ?? "", data: PickerType.sexType.data)
        
        var fromAge = pickerDictionary[.age]?[0]
        if fromAge == "არცერთი" {
            fromAge = ""
        }
        
        var toAge = pickerDictionary[.age]?[1]
        if toAge == "არცერთი" {
            toAge = ""
        }
        
        return StatementSearchEntity(gender: PickerType.sexType.requestData[sexType],
                              city: PickerType.city.requestData[city],
                              relationType: PickerType.relativeType.requestData[relativeType],
                              bloodType: PickerType.bloodType.requestData[bloodType],
                              fromAge: fromAge ?? "",
                              toAge: toAge ?? ""
                              , query: "")
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
                return ["არცერთი", "a", "b", "ab"]
            case .relativeType:
                return ["არცერთი", "დედა", "მამა", "ძმა", "და", "ქალიშვილი", "ვაჟიშვილი", "მეგობარი"]
            case .sexType:
                return ["არცერთი", "მდედრობითი", "მამრობითი"]
            case .city:
                return ["არცერთი", "Tbilisi", "Batumi", "Kutaisi", "Gori", "Other"]
            case .age:
                return getAgeArray()
            }
        }
        
        var requestData: [String] {
            switch self {
            case .bloodType:
                return ["", "a", "b", "ab"]
            case .relativeType:
                return ["", "mother", "father", "brother", "sister", "daughter", "son", "friend"]
            case .sexType:
                return ["", "female", "male"]
            case .city:
                return ["", "თბილისი", "ბათუმი", "ქუთაისი", "გორი"]
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
            var arr: [String] = ["არცერთი"]
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
