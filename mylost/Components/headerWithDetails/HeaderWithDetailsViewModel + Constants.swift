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
        let onTap: ((_ isFavourite: Bool) -> ())?
         init(icon: ImageType?,
              title: String?,
              info1: String? = nil,
              info2: String? = nil,
              info3: String? = nil,
              info4: String? = nil,
              description: String?,
              onTap: ((_ isFavourite: Bool) -> ())? = nil) {
            self.icon = icon
            self.title = title
            self.info1 = info1
            self.info2 = info2
            self.info3 = info3
            self.info4 = info4
            self.description = description
            self.onTap = onTap
        }
    }
    
    enum ImageType {
        case withIcon(icon: UIImage)
        case withURL(url: URL?)
    }
}
