//  
//  RegistrationPresenter.swift
//  Registration
//
//  Created by Nato Egnatashvili on 22.08.21.
//

import UIKit

protocol RegistrationView: AnyObject {
    var tableView: UITableView {get}
}

protocol RegistrationPresenter {
    func viewDidLoad()
}

class RegistrationPresenterImpl: RegistrationPresenter {
    
    private weak var view: RegistrationView?
    private var router: RegistrationRouter
    private var tableViewDataSource: ListViewDataSource?
    
    init(view: RegistrationView, router: RegistrationRouter) {
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
                    RoundedTextFieldTableCell.self
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
    
    private func textFieldSections() -> ListSection {
        ListSection(
            id: "",
            rows:  [textfield()])
    }
    
    private func textfield() -> ListRow <RoundedTextFieldTableCell>{
        ListRow(model: RoundedTextFieldTableCell.Model.init(placeHolderText: "სახელი",
                                                            title: "",
                                                            onTap: { _ in
            print("lala")
        }),
                height: UITableView.automaticDimension,
                tapClosure: {_,_ in
            print("nothing")
        })
    }
}
