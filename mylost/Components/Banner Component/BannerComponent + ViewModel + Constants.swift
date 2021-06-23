//
//  BannerComponent + ViewModel + Constants.swift
//  mylost
//
//  Created by Nato Egnatashvili on 6/23/21.
//

import UIKit

extension  BannerComponent {
    public struct ViewModel {
        let title: String?
        let description: String
        let type: Bannertype
        
        public init (type: Bannertype, title: String? = nil, description: String) {
            self.type = type
            self.title = title
            self.description = description
        }
    }
}

public enum Bannertype {
    case positive
    case negative
    case informative
}

extension Bannertype {
    var background: UIColor {
        switch self {
        case .positive:
            return Resourcebook.Color.Positive.solid50.uiColor
        case .informative:
            return Resourcebook.Color.Information.solid50.uiColor
        case .negative:
            return Resourcebook.Color.Negative.solid50.uiColor
        }
    }
}
