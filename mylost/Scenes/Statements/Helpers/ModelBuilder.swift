//
//  ModelBuilder.swift
//  mylost
//
//  Created by Nato Egnatashvili on 01.09.21.
//

import Foundation
import Components

extension StatementsPresenterImpl {
    struct ModelBuilder {
        
        var getEmptyPageDescription: PageDescription.ViewModel {
            .init(imageType: (
                    image: Resourcebook.Image.Icons24.systemInfoFill.template,
                    tint: Resourcebook.Color.Information.solid25.uiColor),
                  title: "ბლოგები ვერ მოიძებნა",
                  description: "ვერ მოიძებნა ბლოგები. გთხოვთ სცადეთ მოგვიანებით")
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
