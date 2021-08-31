//
//  UserController.swift
//  mylost
//
//  Created by Nato Egnatashvili on 13.08.21.
//

import UIKit
import RxSwift
import RxCocoa

class UserController: UIViewController, UITableViewDelegate {
    
    fileprivate let bag = DisposeBag()
    
    private  var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.backgroundColor = .red
        table.translatesAutoresizingMaskIntoConstraints = false
        table.separatorStyle = .none
        return table
    }()
    
    let userViewModelInstance = UserViewModel()
    let userList = BehaviorRelay<[UserDetailModel]>(value: [])
    let filteredList = BehaviorRelay<[UserDetailModel]>(value: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(tableView)
        tableView.top(toView: self.view)
        tableView.right(toView: self.view)
        tableView.bottom(toView: self.view)
        tableView.left(toView: self.view)
        tableView.register(UINib.init(nibName: "UserDetailCell",
                                      bundle: nil),
                           forCellReuseIdentifier: "UserDetailCell")
        self.view.backgroundColor = .white
        userViewModelInstance.fetchUserList()
        bindUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func bindUI() {
        
        //Here we subscribe the subject in viewModel to get the value here
        userViewModelInstance.userViewModelObserver.subscribe(onNext: { (value) in
            self.filteredList.accept(value)
            self.userList.accept(value)
        },onError: { error in
            self.errorAlert()
        }).disposed(by: bag)
        
        
        userList.bind(to: tableView.rx.items(cellIdentifier: "UserDetailCell",
                                             cellType: UserDetailCell.self)){row ,model ,cell in
            cell.configure(with: .init(name: model.userData.first_name,
                                       lastname: model.userData.last_name,
                                       date: model.userData.avatar,
                                       buttonHandler: { _ in
                let userDetail = UserDetailsController()
                userDetail.user = model
                self.navigationController?.pushViewController(userDetail, animated: true)
                print(model.isFavorite.value)
            }))
        }.disposed(by: bag)
        
    }
    
    
    func errorAlert() {
        let alert = UIAlertController(title: "Error", message: "Check your Internet connection and Try Again!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
