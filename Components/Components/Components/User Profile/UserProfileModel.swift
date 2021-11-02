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
        let description: String?
        let onTap: ((SavedUserCard) -> Void)?
        
        public init(avatar: UIImage, username: String, description: String? = nil, onTap: ((SavedUserCard) -> ())?) {
            self.avatar = avatar
            self.username = username
            self.description = description
            self.onTap = onTap
        }
        
    }
    
    struct Constants {
        struct Avatar {
            static let size: CGSize = .init(width: 40, height: 40)
        }
        
        struct Title {
            static var textColor: UIColor? { Resourcebook.Color.Information.tr300.uiColor }
            static let font = Resourcebook.Font.body2
        }
        
        struct Username {
            static var textColor: UIColor? { Resourcebook.Color.Invert.Component.tr400.uiColor }
            static let font = Resourcebook.Font.body2
        }
        
    }
    
}
