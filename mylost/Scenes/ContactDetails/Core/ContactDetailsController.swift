//  
//  ContactDetailsController.swift
//  mylost
//
//  Created by Nato Egnatashvili on 06.09.21.
//

import UIKit

class ContactDetailsViewController: UIViewController {

    var presenter: ContactDetailsPresenter?
    
    var headerView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.height(equalTo: 36)
        view.width(equalTo: 36)
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 18
        return view
    }()
    
    
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
        self.view.backgroundColor = Resourcebook.Color.Invert.Background.canvas.uiColor
        self.view.addSubview(headerView)
        headerView.top(toView: self.view)
        headerView.left(toView: self.view, constant: 16)
        
        self.view.addSubview(tableView)
        
        tableView.relativeTop(toView: headerView)
        tableView.left(toView: self.view)
        tableView.right(toView: self.view)
        tableView.bottom(toView: self.view)
    }
    
    func setImg(with url: String) {
        headerView.sd_setImage(with: URL(string: url)) { _, _, _, _ in
            self.view.layoutSubviews()
        }
    }
}

extension ContactDetailsViewController: ContactDetailsView {
    func displayBanner(type: Bannertype, title: String, description: String) {
        DispatchQueue.main.async {
            self.displayBanner(banner: .init(type: type, title: title, description: description))
        }
    }
}

extension ContactDetailsViewController: customNavigatable {
    var navTiTle: String {
        "კონტაქტის დეტალები"
    }
}
