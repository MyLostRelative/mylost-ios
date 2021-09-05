//
//  MyProfileRouter.swift
//  mylost
//
//  Created by Nato Egnatashvili on 01.09.21.
//

import Foundation

protocol MyProfileRouter {
    func attach(controller: MyProfileViewController)
    func move2ProfileDetails()
}

class MyProfileRouterImpl: MyProfileRouter {
    private weak var controller: MyProfileViewController?
    
    func attach(controller: MyProfileViewController) {
        self.controller = controller
    }
    
    func move2ProfileDetails() {
        guard let vc = DIAssembly(uiAssemblies: [DetailsAndLogOutAssembly()], networkAssemblies: []).resolver.resolve(DetailsAndLogOutController.self) else { return }
        controller?.navigationController?.pushViewController(vc, animated: true)
    }
}
