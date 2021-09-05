//  
//  DetailsAndLogOutRouter.swift
//  mylost
//
//  Created by Nato Egnatashvili on 04.09.21.
//

import Foundation

protocol DetailsAndLogOutRouter {
    func attach(controller: DetailsAndLogOutController)
    func changeToLogOut()
    func backToProfile()
}

class DetailsAndLogOutRouterImpl: DetailsAndLogOutRouter {
    
    private weak var controller: DetailsAndLogOutController?
    
    func attach(controller: DetailsAndLogOutController) {
        self.controller = controller
    }
    
    func changeToLogOut() {
        for i in self.controller?.navigationController?.viewControllers ?? [] {
            if let vc = i as? ProductContainer {
                vc.userType = .guest
                self.controller?.navigationController?.viewControllers.removeLast()
                self.controller?.navigationController?.viewControllers.removeLast()
            }
        }
    }
    
    func backToProfile() {
            self.controller?.navigationController?.viewControllers.removeLast()
    }
    
}
