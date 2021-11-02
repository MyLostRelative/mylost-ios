//
//  RowItemModel.swift
//  mylost
//
//  Created by Nato Egnatashvili on 05.09.21.
//

import UIKit

extension RowItem {
    public struct ViewModel {
        let icon: UIImage?
        let title: String?
        let description: String
        
        public init(icon: UIImage? = nil, title: String?, description: String) {
            self.icon = icon
            self.title = title
            self.description = description
        }
    }
}
