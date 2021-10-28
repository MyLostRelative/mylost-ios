//
//  TwoInputTableCellModel.swift
//  mylost
//
//  Created by Nato Egnatashvili on 27.10.21.
//

import Foundation

extension TwoInputTableCell {
    
    public struct ViewModel {
        let firstInputPlaceHolder: String
        let secondInputPlaceHolder: String
        weak var delegate: TwoInputTableCellDelegate?
    }
}
