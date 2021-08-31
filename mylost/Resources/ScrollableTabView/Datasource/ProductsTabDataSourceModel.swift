//
//  ProductsTabDataSourceModel.swift
//  mBank
//
//  Created by Nato Egnatashvili on 4/8/21.
//  Copyright © 2021 Bank Of Georgia. All rights reserved.
//

import Foundation

class ProductsTabDataSource {
    func models() -> [ProductTabModel] {
        return [
            ProductTabModel.init(
               title: "Sign In",
               state: ProductTabCell.State.active
               )
            , ProductTabModel.init(
            title: "My Lost",
            state: ProductTabCell.State.disabled
            ) ,
        ProductTabModel.init(
            title: "Statement",
            state: ProductTabCell.State.disabled
            )]
    }
}
