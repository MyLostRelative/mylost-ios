//  
//  FilterDetailsController.swift
//  mylost
//
//  Created by Nato Egnatashvili on 06.09.21.
//

import UIKit
import Components

class FilterDetailsViewController: UIViewController {

    var presenter: FilterDetailsPresenter?
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

extension FilterDetailsViewController: FilterDetailsView {
    func displayBanner(type: Bannertype, title: String, description: String) {
        DispatchQueue.main.async {
            self.displayBanner(banner: .init(type: type, title: title, description: description))
        }
    }
}

extension FilterDetailsViewController: customNavigatable {
    var navTiTle: String {
        "ფილტრები"
    }
}
