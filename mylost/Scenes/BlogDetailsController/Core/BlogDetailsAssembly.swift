//
//  BlogDetailsAssembly.swift
//  mylost
//
//  Created by Nato Egnatashvili on 05.09.21.
//

import Swinject
import Core

class BlogDetailsAssembly: UIAssembly {
    private let blog: Blog
    
    init(blog: Blog) {
        self.blog = blog
    }
    
    func assemble(container: Container) {
        container.register(BlogDetailsViewController.self) {resolver in
            let controller  = BlogDetailsViewController()
            let presenter = resolver.resolve(BlogDetailsPresenterImpl.self)
            controller.presenter = presenter
            return controller
        }.initCompleted { resolver, vc in
            resolver.resolve(BlogDetailsRouterImpl.self)?.attach(controller: vc)
            resolver.resolve(BlogDetailsPresenterImpl.self)?.attach(view: vc)
        }
        
        container.register(BlogDetailsPresenterImpl.self) {resolver in
            let presenter = BlogDetailsPresenterImpl(router: resolver.resolve(BlogDetailsRouterImpl.self)!,
                                                     blog: self.blog)
            return presenter
        }
        
        container.register(BlogDetailsRouterImpl.self) { _ in
            return BlogDetailsRouterImpl()
        }
    }
}
