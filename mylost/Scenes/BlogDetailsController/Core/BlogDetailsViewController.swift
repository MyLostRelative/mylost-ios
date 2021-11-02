//
//  BlogDetailsViewController.swift
//  mylost
//
//  Created by Nato Egnatashvili on 05.09.21.
//

import UIKit
import LifetimeTracker
import Components

class BlogDetailsViewController: UIViewController , BlogDetailsView , LifetimeTrackable {
    class var lifetimeConfiguration: LifetimeConfiguration {
            return LifetimeConfiguration(maxCount: 1, groupName: "VC")
        }
    
    var presenter: BlogDetailsPresenter?
    
    var tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = Resourcebook.Color.Invert.Background.canvas.uiColor
        table.translatesAutoresizingMaskIntoConstraints = false
        table.separatorStyle = .none
        return table
    }()
    
    override func viewDidLoad() {
        trackLifetime()
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

extension BlogDetailsViewController: customNavigatable {
    var navTiTle: String {
        return "ბლოგის დეტალები"
    }
}
