//
//  TwoInputTableCellModel.swift
//  mylost
//
//  Created by Nato Egnatashvili on 27.10.21.
//

import Foundation

extension TwoInputTableCell {
    
    public struct ViewModel {
        public init(firstInputPlaceHolder: String, secondInputPlaceHolder: String, delegate: TwoInputTableCellDelegate? = nil) {
            self.firstInputPlaceHolder = firstInputPlaceHolder
            self.secondInputPlaceHolder = secondInputPlaceHolder
            self.delegate = delegate
        }
        
        let firstInputPlaceHolder: String
        let secondInputPlaceHolder: String
        weak var delegate: TwoInputTableCellDelegate?
    }
}
