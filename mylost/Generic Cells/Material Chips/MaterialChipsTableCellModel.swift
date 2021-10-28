//
//  MaterialChipsTableCellModel.swift
//  mylost
//
//  Created by Nato Egnatashvili on 27.10.21.
//

import Foundation

extension MaterialChipsTableCell {
    
    public struct ViewModel {
        let chipTitles: [String]
        let onTap: ((String) -> Void)?
    }
}
