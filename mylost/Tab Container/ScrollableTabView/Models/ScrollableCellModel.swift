//
//  ScrollableCellModel.swift
//  mBank
//
//  Created by Nato Egnatashvili on 4/8/21.
//  Copyright © 2021 Bank Of Georgia. All rights reserved.
//

import UIKit
import Components

protocol CollectionConfigurable {
    func configure(model: TabCollectionCellModel)
}

protocol TabCollectionCellModel {
    var nibName: String {get}
    var width: CGFloat {get}
    var backgroundColor: UIColor? {get}
}

struct ProductTabModel:  TabCollectionCellModel{
    var title: String
    var state: ProductTabCell.State
    var nibName: String {return "ProductTabCell"}
    var tabTitleWidth: CGFloat {return title.width(withConstraintedHeight: 15, font: Resourcebook.Font.captionBig)}
    
    var width: CGFloat {return tabTitleWidth + AppScrollableTabs.ProductTab.padding}
    var backgroundColor: UIColor? {return  AppScrollableTabs.ProductTab.Colors.background}
}

extension String{
    func width(withConstraintedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
    
}
