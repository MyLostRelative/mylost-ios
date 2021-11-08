//  
//  MyLostHomeController.swift
//  mylost
//
//  Created by Nato Egnatashvili on 6/21/21.
//

import UIKit
import Components

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
        // navigationController?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        mypresenter?.viewWillAppear()
    }
    
    private func addTableView() {
        self.view.addSubview(tableView)
        
        tableView.top(toView: self.view)
        tableView.left(toView: self.view)
        tableView.right(toView: self.view)
        tableView.bottom(toView: self.view)
    }
    
    private func addSubv() {
        let v = PageDescriptionTableCell()
        
        v.top(toView: self.view)
        v.left(toView: self.view)
        v.right(toView: self.view)
        v.bottom(toView: self.view)
        v.configure(with: .init(imageType: (image: Resourcebook.Image.Icons48.generalUserBusinessFill.image,
                                            tint: .red),
                                title: "gamarjoba",
                                description: "description cota naklebia"))
        
    }
}

extension MyLostHomeController: MyLostHomeView {
    
    func displayBanner(type: Bannertype, title: String, description: String) {
        self.displayBanner(banner: .init(type: type, title: title, description: description))
    }
}

// extension MyLostHomeController: UINavigationControllerDelegate {
//    func navigationController(
//        _ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation,
//        from fromVC: UIViewController,
//        to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//
//        switch operation {
//        case .push:
//            return TransitionManager(duration: 0.7)
//        default:
//            return nil
//        }
//
//    }
// }

extension MyLostHomeController: customNavigatable {
    var navTiTle: String {
        return "მთავარი გვერდი"
    }
}
