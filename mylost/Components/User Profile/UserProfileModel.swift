//
//  UserProfileModel.swift
//  mylost
//
//  Created by Nato Egnatashvili on 02.09.21.
//

import UIKit


extension SavedUserCard{
    public struct ViewModel {
        let avatar: UIImage
        let username: String
        let age: String?
        let buttonTitle: String
        let onTap: ((SavedUserCard) -> ())?
        
        public init(avatar: UIImage, username: String, age: String? = nil, buttonTitle: String, onTap: ((SavedUserCard) -> ())?) {
            self.avatar = avatar
            self.username = username
            self.age = age
            self.buttonTitle = buttonTitle
            self.onTap = onTap
        }
        
    }

    
    struct Constants {
        
        struct Avatar {
            static let size: CGSize = .init(width: 36, height: 36)
        }
        
        struct Title {
            static var textColor: UIColor? { Resourcebook.Color.Information.tr200.uiColor }
            static let font = Resourcebook.Font.body1
        }
        
        struct Username {
            static var textColor: UIColor? { Resourcebook.Color.Invert.Component.tr400.uiColor }
            static let font = Resourcebook.Font.body2
        }
        
    }
    
}
