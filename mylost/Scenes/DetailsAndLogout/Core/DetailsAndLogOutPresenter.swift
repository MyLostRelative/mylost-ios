//  
//  DetailsAndLogOutPresenter.swift
//  mylost
//
//  Created by Nato Egnatashvili on 04.09.21.
//

import UIKit
import Core
import Components

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
    
    private func pageDescriptionRow() -> ListRow <PageDescriptionTableCell> {
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

// MARK: - Sign Up Section
extension DetailsAndLogOutPresenterImpl {
    private func normalState() -> [ListSection] {
         [pageDescriptionSection(), rowItemSection()]
    }
    
    private func rowItemSection() -> ListSection {
        var rowItems: [ListRow <RowItemTableCell> ] = [self.rowItem(model: .init(title: "username", description: userInfo.username))]
        if let mobile = userInfo.mobileNumber {
            rowItems.append(self.rowItem(model: .init(title: "????????????????????????", description: mobile)))
        }
        if let email = userInfo.email {
            rowItems.append(self.rowItem(model: .init(title: "???????????????", description: email)))
        }
        
        return ListSection(id: "", rows: rowItems)
    }
    
    private func pageDescriptionSection() -> ListSection {
        return ListSection(id: "", rows: [pageDescriptionRow()  ])
    }
}
