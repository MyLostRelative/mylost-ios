//
//  PrimaryButtonModel.swift
//  Components
//
//  Created by Nato Egnatashvili on 08.11.21.
//

import UIKit

extension PrimaryButton {
    public struct ViewModel {
        let image: UIImage?
        let title: String?
        let backgroundColor: UIColor?
        let titleTint: UIColor?
        let onTap: ((PrimaryButton) -> Void)?
        
        public init(image: UIImage? = nil,
                    title: String? = nil,
                    backgroundCOlor: UIColor? = nil ,
                    titleTint: UIColor? = .white,
                    onTap: ((PrimaryButton) -> Void)? = nil) {
            self.image = image
            self.title = title
            self.backgroundColor = backgroundCOlor
            self.titleTint = titleTint
            self.onTap = onTap
        }
    }
    
}
