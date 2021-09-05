//  
//  PostCreateConfigurator.swift
//  mylost
//
//  Created by Nato Egnatashvili on 05.09.21.
//

import Swinject

class PostCreateAssembly: UIAssembly {
    func assemble(container: Container) {
        container.register(PostCreateViewController.self) {resolver in
            let controller  = PostCreateViewController()
            let presenter = resolver.resolve(PostCreatePresenterImpl.self)
            controller.presenter = presenter
            return controller
        }.initCompleted { resolver, vc in
            resolver.resolve(PostCreateRouterImpl.self)?.attach(controller: vc)
            resolver.resolve(PostCreatePresenterImpl.self)?.attach(view: vc)
        }
        
        container.register(PostCreatePresenterImpl.self) {resolver in
            let presenter = PostCreatePresenterImpl(router: resolver.resolve(PostCreateRouterImpl.self)!)
            return presenter
        }
        
        container.register(PostCreateRouterImpl.self) {resolver in
            return PostCreateRouterImpl()
        }
    }
}
