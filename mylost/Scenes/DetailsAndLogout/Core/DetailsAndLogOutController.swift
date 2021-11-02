//  
//  DetailsAndLogOutController.swift
//  mylost
//
//  Created by Nato Egnatashvili on 04.09.21.
//

import UIKit

protocol DetailsAndLogOutView: NSObject {
    var tableView: UITableView {get}
}

class DetailsAndLogOutController: UIViewController {
    var presenter: DetailsAndLogOutPresenter?
    
    internal  var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.backgroundColor = .white
        table.translatesAutoresizingMaskIntoConstraints = false
        table.separatorStyle = .none
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        self.presenter?.viewDidLoad()
    }
    
    private func setUpTableView() {
        self.view.addSubview(tableView)
        tableView.top(toView: self.view)
        tableView.right(toView: self.view)
        tableView.bottom(toView: self.view)
        tableView.left(toView: self.view)
        self.view.backgroundColor = .white
    }
    
}

extension DetailsAndLogOutController: DetailsAndLogOutView {
    
}
