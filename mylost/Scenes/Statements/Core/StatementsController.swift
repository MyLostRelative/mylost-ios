//  
//  StatementsController.swift
//  mylost
//
//  Created by Nato Egnatashvili on 6/21/21.
//

import UIKit
import Components

class StatementsController: UIViewController {

    var statementPresenter: StatementsPresenter?
    var tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = Resourcebook.Color.Invert.Background.canvas.uiColor
        table.translatesAutoresizingMaskIntoConstraints = false
        table.separatorStyle = .none
        return table
    }()
    
    override func viewDidLoad() {
        addTableView()
        statementPresenter?.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        statementPresenter?.viewWillAppear()
    }
    
    private func addTableView() {
        self.view.addSubview(tableView)
        
        tableView.top(toView: self.view)
        tableView.left(toView: self.view)
        tableView.right(toView: self.view)
        tableView.bottom(toView: self.view)
    }
}

extension StatementsController: StatementsView {
    func displayBanner(type: Bannertype, title: String, description: String) {
        self.displayBanner(banner: .init(type: type, title: title, description: description))
    }
}
