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
    func move2Registration()
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
    
    func move2Registration() {
        guard let vc = DIAssembly(uiAssemblies: [RegistrationAssembly()],
                                  networkAssemblies: [RegistrationNetworkAssembly()])
                .resolver.resolve(RegistrationController.self) else {
                    fatalError("errores")
                }
        controller?.navigationController?.pushViewController(vc,
                                                             animated: true)
    }
    
}
