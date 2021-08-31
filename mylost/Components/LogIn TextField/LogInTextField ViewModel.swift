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
        let textType: textFieldType
        let onTap: ((LogInTextField) -> ())?
        
        public init(title: String?, textType: textFieldType = .normal, onTap:  ((LogInTextField) -> ())?) {
            self.title = title
            self.textType = textType
            self.onTap = onTap
        }
    }
    
    public enum textFieldType {
        case normal
        case secury
    }
}
