//
//  ButtonWithLine View Model + COnstant.swift
//  mylost
//
//  Created by Nato Egnatashvili on 6/21/21.
//

import Foundation

extension ButtonWithLine {
    public struct ViewModel {
        let title: String
        let onTap: ((ButtonWithLine) -> ())?
    }
}
