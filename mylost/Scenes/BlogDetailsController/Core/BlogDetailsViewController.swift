//
//  BlogDetailsViewController.swift
//  mylost
//
//  Created by Nato Egnatashvili on 05.09.21.
//

import UIKit

class BlogDetailsViewController: UIViewController , BlogDetailsView{

    var presenter: BlogDetailsPresenter?
    
    var tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = Resourcebook.Color.Invert.Background.canvas.uiColor
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
