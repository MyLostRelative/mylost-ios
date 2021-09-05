//
//  SignInRouter.swift
//  SignInRouter
//
//  Created by Nato Egnatashvili on 30.08.21.
//

import Foundation

protocol SignInRouter {
    func attach(controller: SignInViewController)
    func changeToUser() 
}

class SignInRouterImpl: SignInRouter {
    private weak var controller: SignInViewController?
    
    func attach(controller: SignInViewController) {
        self.controller = controller
    }
    
    func changeToUser() {
        for i in self.controller?.navigationController?.viewControllers ?? [] {
            if let vc = i as? ProductContainer {
                vc.userType = .user
            }
        }
    }
    
}
