//  
//  RegistrationRouter.swift
//  mylost
//
//  Created by Nato Egnatashvili on 22.10.21.
//

import Foundation

protocol RegistrationRouter {
    func attach(controller: RegistrationController)
    func changeToUser()
}

class RegistrationRouterImpl: RegistrationRouter {
    
    private weak var controller: RegistrationController?
    
    func changeToUser() {
        for i in self.controller?.navigationController?.viewControllers ?? [] {
            if let vc = i as? ProductContainer {
                vc.userType = .user
                controller?.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func attach(controller: RegistrationController) {
        self.controller = controller
    }
    
}
