//
//  MyProfileRouter.swift
//  mylost
//
//  Created by Nato Egnatashvili on 01.09.21.
//

import Foundation
import Core
import Components
import RxRelay

protocol MyProfileRouter {
    func attach(controller: MyProfileViewController)
    func move2ProfileDetails(userInfo: UserInfo)
    func move2CreatePost(userID: Int, myProfileDelegate: MyProfilePresenterDelegate?)
    func presentActionSheet(sections: [ListSection])
    func move2Fav(favouriteStatements: BehaviorRelay<[Statement]>)
    func move2ReadedBlogs(readedBlogs: BehaviorRelay<[Blog]>) 
    func changeToLogOut()
}

class MyProfileRouterImpl: MyProfileRouter {
    private weak var controller: MyProfileViewController?
    private var actionSheet: SlideActionSheet?
    
    func attach(controller: MyProfileViewController) {
        self.controller = controller
    }
    
    func move2ProfileDetails(userInfo: UserInfo) {
        dismissActionSheet()
        guard let vc = DIAssembly(uiAssemblies: [DetailsAndLogOutAssembly(userInfo: userInfo)],
                                  networkAssemblies: [])
                .resolver
                .resolve(DetailsAndLogOutController.self) else { return }
        controller?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func move2CreatePost(userID: Int, myProfileDelegate: MyProfilePresenterDelegate?) {
        guard let vc = DIAssembly(uiAssemblies: [PostCreateAssembly(userID: userID,
                                                                    myProfileDelegate: myProfileDelegate)],
                                  networkAssemblies: [StatementPostAssembly()])
                .resolver
                .resolve(PostCreateViewController.self) else { return }
        controller?.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func presentActionSheet(sections: [ListSection]) {
        let vc = SlideActionSheet()
        actionSheet = vc
        vc.modalPresentationStyle = .custom
        controller?.present(vc, animated: true, completion: nil)
        vc.configure(with: .init(sections: sections,
                                 reusableClasses: [RowItemTableCell.self,
                                                   PageDescriptionTableCell.self]))
    }
    
    func move2Fav(favouriteStatements: BehaviorRelay<[Statement]>) {
        guard let vc = DIAssembly(
            uiAssemblies: [FavouriteStatementsAssembly(favouriteStatements: favouriteStatements)],
            networkAssemblies: [])
                .resolver
                .resolve(FavouriteStatementsController.self) else { return }
        dismissActionSheet()
        self.controller?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func move2ReadedBlogs(readedBlogs: BehaviorRelay<[Blog]>) {
        guard let vc = DIAssembly.init(uiAssemblies: [ReadedBlogsAssembly(readedBlogs: readedBlogs)],
                        networkAssemblies: [])
            .resolver
                .resolve(ReadedBlogsController.self) else { return }
        dismissActionSheet()
        self.controller?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func changeToLogOut() {
        dismissActionSheet()
        for i in self.controller?.navigationController?.viewControllers ?? [] {
            if let vc = i as? ProductContainer {
                vc.userType = .guest
                self.controller?.navigationController?.viewControllers.removeLast()
                self.controller?.navigationController?.viewControllers.removeLast()
            }
        }
    }
    
    private func dismissActionSheet() {
        self.actionSheet?.dismiss(animated: true, completion:  nil)
    }
}
