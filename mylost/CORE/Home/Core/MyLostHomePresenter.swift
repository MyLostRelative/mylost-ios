//  
//  MyLostHomePresenter.swift
//  mylost
//
//  Created by Nato Egnatashvili on 6/21/21.
//

import UIKit

protocol MyLostHomeView: AnyObject {
    var tableView: UITableView {get}
    func displayBanner(type: Bannertype, title: String, description: String)
}

protocol MyLostHomePresenter {
    func viewDidLoad()
}

class MyLostHomePresenterImpl: MyLostHomePresenter {
    
    private weak var view: MyLostHomeView?
    private var router: MyLostHomeRouter
    private var tableViewDataSource: ListViewDataSource?
    
    init(view: MyLostHomeView, router: MyLostHomeRouter) {
        self.view = view
        self.router = router
    }
    
    func viewDidLoad() {
        configureDataSource()
        constructDataSource()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.view?.displayBanner(type: .positive, title: "ოპერაცია წარმატებით შესრულდა",
                                     description: "თქვენ მიერ განხორციელებული ტრანზაქციები წარმატებით შესრულდა.")
        }
    }
    
    private func configureDataSource() {
        self.view.unwrap { v in
            tableViewDataSource = ListViewDataSource.init(
                tableView: v.tableView,
                withClasses: [
                    RoundedTextFieldTableCell.self,
                    HeaderWithDetailsCell.self,
                    TitleAndDescriptionCardTableCell.self
                ],
                reusableViews: [
                ])
        }
    }
    
    private func constructDataSource() {
        DispatchQueue.main.async {
            self.tableViewDataSource?.reload(
                with: [
                    ListSection.init(
                        id: "",
                        rows: [self.textfield(), self.headerDesc(), self.cardWithHeader()] ,
                        changes: []
                )]
            )
        }
    }
    
    private func textfield() -> ListRow <RoundedTextFieldTableCell>{
        ListRow(model: RoundedTextFieldTableCell.Model(placeHolderText: "დაწერეთ",
                                                       title: "დაპოსტვა",
                                                       onTap: { (field) in
                                                        print(field.getText())
                                                       }),
                height: UITableView.automaticDimension)
    }
    
    private func headerDesc() -> ListRow <HeaderWithDetailsCell>{
        ListRow(model: HeaderWithDetails.ViewModel(icon: Resourcebook.Image.Icons24.cardCreditFill.image,
                                                   title: "ნატო ეგნატაშვილი",
                                                   description: "თქვენი დროით 12 აპრილს"),
                height: UITableView.automaticDimension)
    }
    
    private func cardWithHeader() -> ListRow <TitleAndDescriptionCardTableCell>{
        ListRow(
            model: TitleAndDescriptionCardTableCell.Model(
                headerModel: .init(icon: Resourcebook.Image.Icons24.cardCreditFill.image,
                              title: "ნატო ეგნატაშვილი",
                              description: "თქვენი დროით 12 აპრილს"),
                cardModel: .init(title: "განცხადება ესა და ესაა",
                                 description: "გაუთვალისწინებელი შემთხვევის დროს, შეგიძლია მომენტალურად გაიაქტიურო ანაბრით უზრუნველყოფილი სესხი შეღავათიანი პირობით და მისი დარღვევის გარეშე ისარგებლო ანაბარზე არსებული თანხით.")),
            height: UITableView.automaticDimension)
    }
}


