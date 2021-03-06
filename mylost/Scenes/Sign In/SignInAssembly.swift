//
//  SignInAssembly.swift
//  SignInAssembly
//
//  Created by Nato Egnatashvili on 30.08.21.
//

import Swinject
import Core

class SignInAssembly: UIAssembly {
    func assemble(container: Container) {
        container.register(SignInViewController.self) {resolver in
            let controller  = SignInViewController()
            let presenter = resolver.resolve(SignInPresenterImpl.self)
            controller.presenter = presenter
            return controller
        }.initCompleted { resolver, vc in
            resolver.resolve(SignInRouterImpl.self)?.attach(controller: vc)
            resolver.resolve(SignInPresenterImpl.self)?.attach(view: vc)
        }
        
        container.register(SignInPresenterImpl.self) {resolver in
            let presenter = SignInPresenterImpl(router: resolver.resolve(SignInRouterImpl.self)!,
                                                loginGateway: resolver.resolve(LoginGatewayImpl.self)!,
                                                registrationGateway: resolver.resolve(RegistrationGatewayImpl.self)!)
            return presenter
        }
        
        container.register(SignInRouterImpl.self) {_ in
            return SignInRouterImpl()
        }
    }
}
