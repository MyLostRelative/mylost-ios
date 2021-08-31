//  
//  RegistrationController.swift
//  Registration
//
//  Created by Nato Egnatashvili on 22.08.21.
//

import UIKit

class RegistrationController: UIViewController {

    var presenter: RegistrationPresenter?
    var tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = .blue
        table.translatesAutoresizingMaskIntoConstraints = false
        table.separatorStyle = .none
        return table
    }()
    
    override func viewDidLoad() {
        addTableView()
        presenter?.viewDidLoad()
    }
    
    private func addTableView() {
        self.view.addSubview(tableView)
        
        tableView.top(toView: self.view)
        tableView.left(toView: self.view)
        tableView.right(toView: self.view)
        tableView.bottom(toView: self.view)
    }
}

extension RegistrationController: RegistrationView {
    
}

