//
//  MyProfileRouter.swift
//  mylost
//
//  Created by Nato Egnatashvili on 01.09.21.
//

import Foundation

protocol MyProfileRouter {
    func attach(controller: MyProfileViewController)
    func move2ProfileDetails(userInfo: UserInfo)
    func move2CreatePost(userID: Int, myProfileDelegate: MyProfilePresenterDelegate?)
}

class MyProfileRouterImpl: MyProfileRouter {
    private weak var controller: MyProfileViewController?
    
    func attach(controller: MyProfileViewController) {
        self.controller = controller
    }
    
    func move2ProfileDetails(userInfo: UserInfo) {
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
}
