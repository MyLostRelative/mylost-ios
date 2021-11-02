//
//  MyProfileSliderActionSheetFactory.swift
//  mylost
//
//  Created by Nato Egnatashvili on 01.11.21.
//

import Components
import UIKit

protocol MyProfileSliderActionSheetFactory {
    func profileDescriptionSection(
        name: String,
        mail: String?) -> ListSection
    func menuItemsSection(items: [MyProfilePresenterImpl.MyProfileMenuType]) -> ListSection
}

class MyProfileSliderActionSheetFactoryImpl: MyProfileSliderActionSheetFactory {
    
    func profileDescriptionSection(
        name: String,
        mail: String?) -> ListSection {
            let pageDescRow = pageDescriptionRow(model: getProfileDescription(name: name,
                                                                              mail: mail))
            return ListSection(id: "profile",
                               rows: [pageDescRow])
        }
    
    func menuItemsSection(items: [MyProfilePresenterImpl.MyProfileMenuType]) -> ListSection {
        let rows = items.map({
            rowItem(model: $0.rowItemModel,
                    onTap: $0.getTap())
        })
        return ListSection(id: "menu",
                           rows: rows)
    }
}

// MARK: - Rows
extension MyProfileSliderActionSheetFactoryImpl {
    
    private func pageDescriptionRow(model: PageDescription.ViewModel) -> ListRow <PageDescriptionTableCell> {
        ListRow(
            model: model,
            height: UITableView.automaticDimension)
    }
    
    private func rowItem(model: RowItem.ViewModel, onTap: (() -> Void)?) -> ListRow <RowItemTableCell> {
        ListRow(model: model,
                height: UITableView.automaticDimension, tapClosure: { _,_,_ in
            onTap?()
        })
    }
}

// MARK: - View Models
extension MyProfileSliderActionSheetFactoryImpl {
    
    private func getProfileDescription(name: String, mail: String?) -> PageDescription.ViewModel {
        .init(imageType: (
            image: Resourcebook.Image.Icons24.systemInfoFill.template,
            tint: Resourcebook.Color.Information.solid25.uiColor),
              title: name,
              description: mail)
    }
    
    private func getFavouriteRowItem() -> RowItem.ViewModel {
        .init(icon: Resourcebook.Image.Icons48.systemStarFill.image,
              title: nil,
              description: "ფავორიტების ნახვა")
    }
    
    private func getReadedRowItem() -> RowItem.ViewModel {
        .init(icon: Resourcebook.Image.Icons48.systemStarFill.image,
              title: nil,
              description: "წაკითხულების ნახვა")
    }
}
