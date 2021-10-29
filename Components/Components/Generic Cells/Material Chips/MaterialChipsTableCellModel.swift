//
//  MaterialChipsTableCellModel.swift
//  mylost
//
//  Created by Nato Egnatashvili on 27.10.21.
//

import Foundation

extension MaterialChipsTableCell {
    
    public struct ViewModel {
        public init(chipTitles: [String], onTap: ((String) -> Void)?) {
            self.chipTitles = chipTitles
            self.onTap = onTap
        }
        
        let chipTitles: [String]
        let onTap: ((String) -> Void)?
    }
}
