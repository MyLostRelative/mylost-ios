//
//  MyProfileMenuModels.swift
//  mylost
//
//  Created by Nato Egnatashvili on 01.11.21.
//

import Components

extension MyProfilePresenterImpl {
    enum MyProfileMenuType {
        case favouriteStatement(tap: (() -> Void)?)
        case readedBlogStatement(tap: (() -> Void)?)
        case profileDetail(tap: (() -> Void)?)
        case logout(tap: (() -> Void)?)
    }
}

extension MyProfilePresenterImpl.MyProfileMenuType {
    func getTap() -> (() -> Void)? {
        switch self {
        case .favouriteStatement(let tap):
            return tap
        case .readedBlogStatement(let tap):
            return tap
        case .profileDetail(let tap):
            return tap
        case .logout(let tap):
            return tap
        }
    }
    
    var rowItemModel: RowItem.ViewModel {
        switch self {
        case .favouriteStatement(_):
            return .init(icon: Resourcebook.Image.Icons48.systemStarFill.image,
                         title: nil,
                         description: "გაფავორიტებული განცხადებების სია")
        case .readedBlogStatement(_):
            return .init(icon: Resourcebook.Image.Icons48.contactsEmailCloseFill.image,
                         title: nil,
                         description: "წაკითხული ბლოგების სია")
        case .profileDetail(_):
            return .init(icon: Resourcebook.Image.Icons48.generalLoginHistoryFill.image,
                                title: nil,
                                description: "პროფილის დეტალები")
        case .logout(_):
            return .init(icon: Resourcebook.Image.Icons48.systemLogOut.image,
                         title: nil,
                         description: "გამოსვლა")
        }
    }
}
