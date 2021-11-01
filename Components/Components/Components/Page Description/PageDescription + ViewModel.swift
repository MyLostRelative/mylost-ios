//
//  PageDescription + ViewModel.swift
//  mylost
//
//  Created by Nato Egnatashvili on 6/27/21.
//

import UIKit

extension PageDescription {
    public struct ViewModel {
        let imageType: (image: UIImage, tint: UIColor)
        let title: String?
        let description: String?
        
        public init(imageType: (image: UIImage, tint: UIColor), title: String?, description: String?) {
            self.imageType = imageType
            self.title = title
            self.description = description
        }
        
    }
}
