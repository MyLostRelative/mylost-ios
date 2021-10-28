//  
//  DetailsAndLogOutPresenter.swift
//  mylost
//
//  Created by Nato Egnatashvili on 04.09.21.
//


import UIKit

protocol DetailsAndLogOutPresenter {
    func viewDidLoad()
    func attach(view: DetailsAndLogOutView)
}

class DetailsAndLogOutPresenterImpl: DetailsAndLogOutPresenter {
    
    private weak var view: DetailsAndLogOutView?
    private var tableViewDataSource: ListViewDataSource?
    private var router: DetailsAndLogOutRouter
    private let userInfo: UserInfo
    
    init(router: DetailsAndLogOutRouter, userInfo: UserInfo) {
        self.router = router
        self.userInfo = userInfo
    }
    
    func attach(view: DetailsAndLogOutView) {
        self.view = view
    }
    
    func viewDidLoad() {
        configureDataSource()
        constructDataSource()
    }
    
    private func configureDataSource() {
        self.view.unwrap { v in
            tableViewDataSource = ListViewDataSource.init(
                tableView: v.tableView,
                withClasses: [
                    PageDescriptionTableCell.self,
                    TiTleButtonTableCell.self,
                    RowItemTableCell.self
                ])
        }
    }
    
    private func constructDataSource() {
        DispatchQueue.main.async {
            self.tableViewDataSource?.reload(
                with: self.normalState()
            )
        }
    }
    
    private func pageDescriptionRow() -> ListRow <PageDescriptionTableCell>  {
        ListRow(model: PageDescriptionTableCell.Model(imageType: (image: Resourcebook.Image.Icons24.generalUserRetailFill.template,
                                                                  tint: Resourcebook.Color.Information.solid300.uiColor),
                                                      title: nil,
                                                      description: userInfo.firstName + " " + userInfo.lastName),
                height: UITableView.automaticDimension)
    }

    private func rowItem(model: RowItem.ViewModel) -> ListRow <RowItemTableCell> {
        ListRow(model: model,
                height: UITableView.automaticDimension)
    }
    
    private func clickableLabel(with model: TiTleButtonTableCell.ViewModel) -> ListRow<TiTleButtonTableCell> {
        ListRow(model: model,
                height: UITableView.automaticDimension)
    }
}

//MARK: Sign Up Section
extension DetailsAndLogOutPresenterImpl {
    private func normalState() -> [ListSection]{
         [navigationAndPageDescriptionSection(), rowItemSection(), logOutSection() ]
    }
    
    private func rowItemSection() -> ListSection {
        var rowItems: [ListRow <RowItemTableCell> ] = [self.rowItem(model: .init(title: "username", description: userInfo.username))]
        if let mobile = userInfo.mobileNumber {
            rowItems.append(self.rowItem(model: .init(title: "ტელეფონი", description: mobile)))
        }
        if let email = userInfo.email {
            rowItems.append(self.rowItem(model: .init(title: "მეილი", description: email)))
        }
        
        return ListSection(id: "", rows: rowItems)
    }
    
    private func navigationAndPageDescriptionSection() -> ListSection{
        let clickableLabel = clickableLabel(with: .init(title: "უკან დაბრუნება",
                                                   onTap: { _ in
                                                    self.router.backToProfile()
                                                   }))
        return ListSection(id: "", rows: [clickableLabel , pageDescriptionRow()  ])
    }
    
    private func logOutSection() -> ListSection {
        let logOutLabel = clickableLabel(with: .init(title: "გასვლა",
                                                     colorStyle: .negative,
                                                     onTap: { _ in
                                                        UserDefaultManagerImpl().removeValue(key: "token")
                                                        self.router.changeToLogOut()
                                                     }))
        return ListSection(id: "", rows: [logOutLabel ])
    }
}
