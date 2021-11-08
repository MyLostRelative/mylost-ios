//
//  ProductsTabDataSourceModel.swift
//  mBank
//
//  Created by Nato Egnatashvili on 4/8/21.
//  Copyright © 2021 Bank Of Georgia. All rights reserved.
//

import Foundation
import Components

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

class TipDataSource {
    func models() -> [TipModel] {
        [TipModel.init(title: "ეს არის დასალოგინებელი გვერდი, როდესაც დალოგინდებით ეს ტაბი გახდება პროფილის ტაბი , სადაც თქვენ შეგეძლებათ ნახოთ თქვენი დადებული განცხადებები, ნახო თქვენ პროფილზე დაწკაპებით მენიუ.",
                       buttonTitle: "შემდეგი",
                       buttonColor: Resourcebook.Color.Positive.tr200.uiColor),
         TipModel.init(title: "ეს არის განცხადებების გვერდი, აქ შეგიძლიათ ნახოთ განცხადებები, გაფილტროთ ისინი როგორც სურს. არის გაფავორიტების ღილაკი, რითაც თქვენ ამ განცხადებას გააფავორიტებთ და შეგეძლებათ ფავორიტების სიაში ნახვა.",
                        buttonTitle: "შემდეგი",
                        buttonColor: Resourcebook.Color.Positive.tr200.uiColor),
         TipModel.init(title: "ეს არის ბლოგების გვერდი. სადაც თქვენ შეგეძლებათ ნახოთ ბლოგები, რომლებსაც ხალხი წერს. შეგიძლიათ მონიშნოთ როგორც წაკითხული ბლოგი და ის შეგენახებათ.",
                        buttonTitle: "დახურვა",
                       buttonColor: Resourcebook.Color.Negative.tr200.uiColor)]
    }
}
