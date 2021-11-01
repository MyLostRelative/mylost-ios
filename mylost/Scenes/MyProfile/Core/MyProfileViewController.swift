//
//  MyProfileViewController.swift
//  mylost
//
//  Created by Nato Egnatashvili on 01.09.21.
//

import UIKit
import Components

protocol MyProfileView: AnyObject {
    var tableView: UITableView {get}
    func displayBanner(type: Bannertype, title: String, description: String)
}

class MyProfileViewController: UIViewController {
    var presenter: MyProfilePresenter?
    
    internal  var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.backgroundColor = Resourcebook.Color.Invert.Background.canvas.uiColor
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

extension MyProfileViewController: MyProfileView {
        func displayBanner(type: Bannertype, title: String, description: String) {
            DispatchQueue.main.async {
                self.displayBanner(banner: .init(type: type, title: title, description: description))
            }
        }
}


