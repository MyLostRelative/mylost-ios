//  
//  MyLostHomeController.swift
//  mylost
//
//  Created by Nato Egnatashvili on 6/21/21.
//

import UIKit

class MyLostHomeController: UIViewController {

    var mypresenter: MyLostHomePresenter?
    var tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = Resourcebook.Color.Invert.Background.canvas.uiColor
        table.translatesAutoresizingMaskIntoConstraints = false
        table.separatorStyle = .none
        return table
    }()
    
    override func viewDidLoad() {
        addTableView()
        mypresenter?.viewDidLoad()
    }
    
    private func addTableView() {
        self.view.addSubview(tableView)
        
        tableView.top(toView: self.view)
        tableView.left(toView: self.view)
        tableView.right(toView: self.view)
        tableView.bottom(toView: self.view)
    }
}

extension MyLostHomeController: MyLostHomeView {
    func displayBanner(type: Bannertype, title: String, description: String) {
        self.displayBanner(banner: .init(type: type, title: title, description: description))
    }
}

