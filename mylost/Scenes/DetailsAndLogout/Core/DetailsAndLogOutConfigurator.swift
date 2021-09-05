//  
//  DetailsAndLogOutConfigurator.swift
//  mylost
//
//  Created by Nato Egnatashvili on 04.09.21.
//

import Swinject

class DetailsAndLogOutAssembly: UIAssembly {
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
            let presenter = DetailsAndLogOutPresenterImpl(router: resolver.resolve(DetailsAndLogOutRouterImpl.self)!)
            return presenter
        }
        
        container.register(DetailsAndLogOutRouterImpl.self) {resolver in
            return DetailsAndLogOutRouterImpl()
        }
    }
}