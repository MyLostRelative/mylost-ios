//
//  ReadedBlogsFactory.swift
//  mylost
//
//  Created by Nato Egnatashvili on 27.10.21.
//

import Foundation
import Core
import Components

protocol ReadedBlogsFactory {
    func getTitleAndDescription( blog: Blog,
                                 onTap: ((HeaderWithDetails) -> Void)? ) ->  TitleAndDescriptionCardTableCell.CellModel
}

class ReadedBlogsFactoryImpl: ReadedBlogsFactory {
    
    func getTitleAndDescription(
        blog: Blog,
        onTap: ((HeaderWithDetails) -> Void)? ) ->  TitleAndDescriptionCardTableCell.CellModel {
        return TitleAndDescriptionCardTableCell.CellModel(
            headerModel: headerModel(blog: blog, onTap: onTap),
            cardModel: getCardModel(description: blog.statementDescription))
    }
    
    private func getCardModel(description: String) -> RoundedTitleAndDescription.ViewModel {
        RoundedTitleAndDescription.ViewModel(title: "",
                                             description: description)
    }
    
    private func headerModel(
        blog: Blog,
        onTap: ((HeaderWithDetails) -> Void)?) -> HeaderWithDetailsCell.Model {
        HeaderWithDetailsCell.Model(
            icon: .withURL(url: URL(string: blog.imageUrl ?? "")),
            title: "განცხადება: " + blog.statementTitle,
            description: nil,
            rightIcon: getBlogRightIcon(onTap: onTap))
    }
    
    private func getBlogRightIcon(onTap: ((HeaderWithDetails) -> Void)?) -> HeaderWithDetails.RightIcon {
        HeaderWithDetails.RightIcon(
            rightIconIsActive: true,
            rightIconActive: Resourcebook.Image.Icons24.contactsEmailCloseFill.image,
            rightIconDissable: Resourcebook.Image.Icons24.contactsEmailCloseOutline.image,
            rightIconHide: false,
            onTap: onTap)
    }
}
