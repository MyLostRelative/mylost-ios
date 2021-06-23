//
//  RoundedTextFieldViewModel + Constants.swift
//  mylost
//
//  Created by Nato Egnatashvili on 6/21/21.
//

import Foundation

extension RoundedTextField {
    public struct ViewModel {
        let placeHolderText: String
        let title: String
        let onTap: ((RoundedTextField) -> ())?
        public init( placeHolderText: String,
                     title: String,
                     onTap: ((RoundedTextField) -> ())?) {
            self.placeHolderText = placeHolderText
            self.title = title
            self.onTap = onTap
        }
    }
}
