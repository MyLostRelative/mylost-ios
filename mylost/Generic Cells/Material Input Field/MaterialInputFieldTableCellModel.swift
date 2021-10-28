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
        let title: String
        let placeHolder: String?
        let inputType: InputType
        weak var delegate: MaterialInputFieldTableCellDelegate?
    }
}
