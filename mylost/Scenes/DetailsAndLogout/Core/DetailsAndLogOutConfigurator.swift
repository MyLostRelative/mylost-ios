//  
//  DetailsAndLogOutConfigurator.swift
//  mylost
//
//  Created by Nato Egnatashvili on 04.09.21.
//

import Swinject
import Core

class DetailsAndLogOutAssembly: UIAssembly {
    private let userInfo: UserInfo
    init(userInfo: UserInfo) {
        self.userInfo = userInfo
    }
    
    func assemble(container: Container) {
        container.register(DetailsAndLogOutController.self) {resolver in
            let controller  = DetailsAndLogOutController()
            let presenter = resolver.resolve(DetailsAndLogOutPresenterImpl.self)
            controller.presenter = presenter
            return controller
        }.initCompleted { resolver, vc in
            resolver.resolve(DetailsAndLogOutRouterImpl.self)?.attach(controller: vc)
            resolver.resolve(DetailsAndLogOutPresenterImpl.self)?.attach(view: vc)
        }
        
        container.register(DetailsAndLogOutPresenterImpl.self) {resolver in
            let presenter = DetailsAndLogOutPresenterImpl(router: resolver.resolve(DetailsAndLogOutRouterImpl.self)!,
                                                          userInfo: self.userInfo)
            return presenter
        }
        
        container.register(DetailsAndLogOutRouterImpl.self) {_ in
            return DetailsAndLogOutRouterImpl()
        }
    }
}
