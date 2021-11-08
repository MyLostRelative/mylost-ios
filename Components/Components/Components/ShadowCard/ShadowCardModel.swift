//
//  ShadowCardModel.swift
//  Components
//
//  Created by Nato Egnatashvili on 08.11.21.
//

import UIKit

extension ShadowCard {
    public struct ViewModel {
        let image: UIImage?
        let title: String?
        let description: String?
        
        public init(image: UIImage? = nil,
                    title: String? = nil,
                    description: String?) {
            self.image = image
            self.title = title
            self.description = description
        }
    }
}
