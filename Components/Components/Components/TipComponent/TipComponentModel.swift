//
//  TipComponentModel.swift
//  Components
//
//  Created by Nato Egnatashvili on 05.11.21.
//

import UIKit

extension TipComponent {
    public struct ViewModel {
        let imageType: (image: UIImage, tint: UIColor)
        let title: String?
        let description: String?
        let type: TipDimensionType
        let buttonType: ButtonType
        let viewFrame: CGRect
        let onTap: ((TipComponent) -> Void)
        
        public init(imageType: (image: UIImage,
                                tint: UIColor),
                    title: String?,
                    description: String?,
                    type: TipDimensionType = .down,
                    buttonType: ButtonType,
                    viewFrame: CGRect,
                    onTap: @escaping ((TipComponent) -> Void)) {
            self.imageType = imageType
            self.title = title
            self.description = description
            self.type = type
            self.buttonType = buttonType
            self.viewFrame = viewFrame
            self.onTap = onTap
        }
        
    }
    
    public enum TipDimensionType {
        case up
        case down
    }
    
    public enum ButtonType {
        case imageWithTitle(title: String, image: UIImage, color: UIColor)
        case title(title: String, color: UIColor)
    }
    
}

