//
//  RoundedTitleAndDescriptionViewModel + Constants.swift
//  mylost
//
//  Created by Nato Egnatashvili on 6/22/21.
//

import UIKit

extension RoundedTitleAndDescription {
    public struct ViewModel {
        let title: String?
        let icon: UIImage?
        let description: String?
        
        public init(title: String?, icon: UIImage? = nil, description: String?) {
            self.title = title
            self.icon = icon
            self.description = description
        }
    }
}
