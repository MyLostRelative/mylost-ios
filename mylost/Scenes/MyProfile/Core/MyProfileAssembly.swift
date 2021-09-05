//
//  MyProfileAssembly.swift
//  mylost
//
//  Created by Nato Egnatashvili on 01.09.21.
//


import Swinject

class MyProfileAssembly: UIAssembly {
    func assemble(container: Container) {
        container.register(MyProfileViewController.self) {resolver in
            let controller  = MyProfileViewController()
            let presenter = resolver.resolve(MyProfilePresenterImpl.self)
            controller.presenter = presenter
            return controller
        }.initCompleted { resolver, vc in
            resolver.resolve(MyProfileRouterImpl.self)?.attach(controller: vc)
            resolver.resolve(MyProfilePresenterImpl.self)?.attach(view: vc)
        }
        
        container.register(MyProfilePresenterImpl.self) {resolver in
            let presenter = MyProfilePresenterImpl(router: resolver.resolve(MyProfileRouterImpl.self)!)
            return presenter
        }
        
        container.register(MyProfileRouterImpl.self) {resolver in
            return MyProfileRouterImpl()
        }
    }
}


