//  
//  ContactDetailsConfigurator.swift
//  mylost
//
//  Created by Nato Egnatashvili on 06.09.21.
//

import Swinject

class ContactDetailsAssembly: UIAssembly {
    private let guestUserID: Int
    init(guestUserID: Int) {
        self.guestUserID = guestUserID
    }

    func assemble(container: Container) {
        container.register(ContactDetailsViewController.self) {resolver in
            let controller  = ContactDetailsViewController()
            let presenter = resolver.resolve(ContactDetailsPresenterImpl.self)
            controller.presenter = presenter
            return controller
        }.initCompleted { resolver, vc in
            resolver.resolve(ContactDetailsRouterImpl.self)?.attach(controller: vc)
            resolver.resolve(ContactDetailsPresenterImpl.self)?.attach(view: vc)
        }
        
        container.register(ContactDetailsPresenterImpl.self) {resolver in
            let presenter = ContactDetailsPresenterImpl(router: resolver.resolve(ContactDetailsRouterImpl.self)!,
                                                        guestUserID: self.guestUserID,
                                                        userInfoGateway: resolver.resolve(UserInfoGatewayImpl.self)!)
            return presenter
        }
        
        container.register(ContactDetailsRouterImpl.self) {resolver in
            return ContactDetailsRouterImpl()
        }
    }
}
