//
//  MaterialInputFieldTableCellModel.swift
//  mylost
//
//  Created by Nato Egnatashvili on 22.10.21.
//

import Foundation

extension MaterialInputFieldTableCell {
    public enum InputType {
        case username
        case password
        case mail
        case name
        case surname
        case mobileNumber
    }
    
    public struct ViewModel {
        public init(title: String, placeHolder: String?, inputType: MaterialInputFieldTableCell.InputType, delegate: MaterialInputFieldTableCellDelegate? = nil) {
            self.title = title
            self.placeHolder = placeHolder
            self.inputType = inputType
            self.delegate = delegate
        }
        
        let title: String
        let placeHolder: String?
        let inputType: InputType
        weak var delegate: MaterialInputFieldTableCellDelegate?
    }
}

public extension  MaterialInputFieldTableCell.InputType {
    
    var title: String {
        switch self {
        case .username:
            return "UserName"
        case .password:
            return "Password"
        case .name:
            return "Name"
        case .surname:
            return "Surname"
        case .mail:
            return "Mail"
        case .mobileNumber:
            return "Mobile Number"
        }
    }
    
    var placeHolder: String {
        switch self {
        case .username:
            return " ჩაწერეთ რა UserName გსურთ"
        case .password:
            return "ჩაწერეთ Password"
        case .name:
            return "თქვენი Name"
        case .surname:
            return "თქვენი Surname"
        case .mail:
            return "თქვენი Mail"
        case .mobileNumber:
            return "თქვენი მობილურის ნომერი"
        }
    }
}
