//  
//  StatementsPresenter.swift
//  mylost
//
//  Created by Nato Egnatashvili on 6/21/21.
//

import UIKit

protocol StatementsView: AnyObject {
    var tableView: UITableView {get}
}

protocol StatementsPresenter {
    func viewDidLoad()
}

class StatementsPresenterImpl: StatementsPresenter {
    
    private weak var view: StatementsView?
    private var router: StatementsRouter
    private var tableViewDataSource: ListViewDataSource?
    
    init(view: StatementsView, router: StatementsRouter) {
        self.view = view
        self.router = router
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
                        rows: [] ,
                        changes: []
                )]
            )
        }
    }
}
