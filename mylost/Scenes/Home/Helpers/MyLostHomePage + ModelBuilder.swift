//
//  MyLostHomePage + ModelBuilder.swift
//  mylost
//
//  Created by Nato Egnatashvili on 6/27/21.
//

import Foundation
import Core
import Components

extension MyLostHomePresenterImpl {
    struct ModelBuilder {
        func getPostModel(tap: ((RoundedTextField) -> Void)?)-> RoundedTextFieldTableCell.Model {
            .init(placeHolderText: "დაწერეთ",
                  title: "დაპოსტვა",
                  onTap: tap)
        }
        
        func getCardModel(with statement: Statement) -> RoundedTitleAndDescription.ViewModel {
            RoundedTitleAndDescription.ViewModel(title: statement.statementTitle,
                                                 description: statement.statementDescription)
        }
        
        var getEmptyPageDescription: PageDescription.ViewModel {
            .init(imageType: (
                image: Resourcebook.Image.Icons24.systemInfoFill.template,
                tint: Resourcebook.Color.Information.solid25.uiColor),
                  title: "თქვენი არ გაქვთ განცხადებები",
                  description: "თქვენი განცხადებების გვერდი ცარიელია. დაპოსტეთ განცხადება რათა განახლდეს გვერდი.")
        }
        
        func getErrorPgaeDescription(tap: ((ButtonWithLine) -> Void)? )-> PageDescriptionWithButtonTableCell.ViewModel {
            PageDescriptionWithButtonTableCell.ViewModel(pageDescriptionModel: .init(
                imageType: (image: Resourcebook.Image.Icons24.systemErrorOutline.template,
                            tint: .red),
                title: "დაფიქსირდა შეცდომა",
                description: "დაფიქსირდა შეცდომა , სცადეთ მოგვიანებით ან დააჭირეთ განახლება ღილაკს"),
                                                         buttonModel: .init(
                                                            title: "განახლება",
                                                            onTap: tap))
        }
    }
}
