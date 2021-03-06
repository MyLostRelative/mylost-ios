//
//  LocalButton.swift
//  mylost
//
//  Created by Nato Egnatashvili on 6/21/21.
//

import UIKit

class LoaclButton: UIButton {
    override var intrinsicContentSize: CGSize {
            get {
                if let thisSize = self.title(for: .normal)?.width(withConstraintedHeight: 50, font: Resourcebook.Font.body1) {
                    return CGSize(width: thisSize + 20 , height: 40)
                }
                return super.intrinsicContentSize
            }
        }
    
    func setLocalButtonTitle() {
        self.frame = CGRect(x: 0.0, y: 0.0, width: 3 * self.intrinsicContentSize.width , height: self.intrinsicContentSize.height)
    }
}

public extension String{
    func width(withConstraintedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
    
}
