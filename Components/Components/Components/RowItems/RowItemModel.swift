//
//  RowItemModel.swift
//  mylost
//
//  Created by Nato Egnatashvili on 05.09.21.
//

import UIKit

extension RowItem {
    public struct ViewModel {
        let title: String?
        let description: String
        
        public init(title: String?, description: String) {
            self.title = title
            self.description = description
        }
    }
}
