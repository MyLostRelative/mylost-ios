//
//  NavBarTitle.swift
//  mylost
//
//  Created by Nato Egnatashvili on 12.09.21.
//

import UIKit

public class NavBarTitle: UILabel {

    public init() {
        super.init(frame: CGRect(
                    origin: .zero,
                    size: CGSize(width: UIScreen.main.bounds.width,
                                 height: 60)))
        commonInit()
    }
    
    public convenience init(with text: String) {
        self.init()
        self.text = text
        textColor = .gray
        font = Resourcebook.Font.headline3
    }
    
    public convenience init(mutableString: NSMutableAttributedString) {
        self.init()
        self.attributedText = mutableString
        numberOfLines = 0
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        textAlignment = .left
        lineBreakMode = .byTruncatingTail
    }
    
    public override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        super.drawText(in: rect.inset(by: insets))
    }
}
