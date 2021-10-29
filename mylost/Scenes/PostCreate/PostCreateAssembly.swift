//  
//  PostCreateConfigurator.swift
//  mylost
//
//  Created by Nato Egnatashvili on 05.09.21.
//

import Swinject
import Core

class PostCreateAssembly: UIAssembly {
    private let userID: Int
    private let myProfileDelegate: MyProfilePresenterDelegate?
    init(userID: Int,
         myProfileDelegate: MyProfilePresenterDelegate?) {
        self.userID = userID
        self.myProfileDelegate = myProfileDelegate
    }
    
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
            let presenter = PostCreatePresenterImpl(router: resolver.resolve(PostCreateRouterImpl.self)!,
                                                    statementPostGateway: resolver.resolve(StatementPostGatewayImpl.self)!,
                                                    userID: self.userID,
                                                    myProfileDelegate: self.myProfileDelegate)
            return presenter
        }
        
        container.register(PostCreateRouterImpl.self) {_ in
            return PostCreateRouterImpl()
        }
    }
}
