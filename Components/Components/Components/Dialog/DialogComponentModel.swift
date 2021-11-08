//
//  DialogComponentModel.swift
//  Components
//
//  Created by Nato Egnatashvili on 08.11.21.
//

import UIKit

extension DialogComponent {
    public struct ViewModel {
        let imageType: (image: UIImage, tint: UIColor)
        let title: String?
        let description: String?
        let firstButtonModel: PrimaryButton.ViewModel
        let secondButtonModel: PrimaryButton.ViewModel
        
        public init(imageType: (image: UIImage,
                                tint: UIColor),
                    title: String?,
                    description: String?,
                    firstButtonModel: PrimaryButton.ViewModel,
                    secondButtonModel: PrimaryButton.ViewModel) {
            self.imageType = imageType
            self.title = title
            self.description = description
            self.firstButtonModel = firstButtonModel
            self.secondButtonModel = secondButtonModel
        }
        
    }

}

