//
//  SignInViewController.swift
//  SignInViewController
//
//  Created by Nato Egnatashvili on 30.08.21.
//

import UIKit

protocol SignInView: AnyObject {
    var tableView: UITableView {get}
    func displayBanner(type: Bannertype, title: String, description: String)
}

class SignInViewController: UIViewController {
    var presenter: SignInPresenter?
    
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

extension SignInViewController: SignInView {
    func displayBanner(type: Bannertype, title: String, description: String) {
        DispatchQueue.main.async {
            self.displayBanner(banner: .init(type: type, title: title, description: description))
        }
    }
}

