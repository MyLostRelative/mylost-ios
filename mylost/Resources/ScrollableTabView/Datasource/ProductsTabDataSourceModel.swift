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
               title: "შესვლა",
               state: ProductTabCell.State.active
               )
            , ProductTabModel.init(
            title: "განცხადებები",
            state: ProductTabCell.State.disabled
            ) ,
        ProductTabModel.init(
            title: "ბლოგები",
            state: ProductTabCell.State.disabled
            )]
    }
    
    func loggedInmodels() -> [ProductTabModel] {
        return [
            ProductTabModel.init(
               title: "პროფილი",
               state: ProductTabCell.State.active
               )
            , ProductTabModel.init(
            title: "განცხადებები",
            state: ProductTabCell.State.disabled
            ) ,
        ProductTabModel.init(
            title: "ბლოგები",
            state: ProductTabCell.State.disabled
            )]
    }
}
