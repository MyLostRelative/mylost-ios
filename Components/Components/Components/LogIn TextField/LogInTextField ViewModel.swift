//
//  LogInTextField ViewModel.swift
//  LogInTextField ViewModel
//
//  Created by Nato Egnatashvili on 30.08.21.
//

import Foundation

extension LogInTextField {
    public struct ViewModel {
        let title: String?
        let textType: TextFieldType
        let onTap: ((LoginTextFieldTableCell) -> ())?
        
        public init(title: String?, textType: TextFieldType = .normal, onTap:  ((LoginTextFieldTableCell) -> Void)?) {
            self.title = title
            self.textType = textType
            self.onTap = onTap
        }
    }
    
    public enum TextFieldType {
        case normal
        case secury
    }
}
