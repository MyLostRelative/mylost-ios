//
//  HeaderWithDetailsViewModel + Constants.swift
//  mylost
//
//  Created by Nato Egnatashvili on 6/22/21.
//

import UIKit

extension HeaderWithDetails {
    public struct ViewModel {
        let icon: ImageType?
        let title: String?
        let info1: String?
        let info2: String?
        let info3: String?
        let info4: String?
        let description: String?
        let isFavourite: Bool
        let hideFavouriteImage: Bool
        let onTap: ((HeaderWithDetails) -> ())?
         init(icon: ImageType?,
              title: String?,
              info1: String? = nil,
              info2: String? = nil,
              info3: String? = nil,
              info4: String? = nil,
              description: String?,
              isFavourite: Bool = false,
              hideFavouriteImage: Bool = false,
              onTap: ((HeaderWithDetails) -> ())? = nil) {
            self.icon = icon
            self.title = title
            self.info1 = info1
            self.info2 = info2
            self.info3 = info3
            self.info4 = info4
            self.description = description
            self.isFavourite = isFavourite
            self.hideFavouriteImage = hideFavouriteImage
            self.onTap = onTap
        }
    }
    
    enum ImageType {
        case withIcon(icon: UIImage)
        case withURL(url: URL?)
    }
}
