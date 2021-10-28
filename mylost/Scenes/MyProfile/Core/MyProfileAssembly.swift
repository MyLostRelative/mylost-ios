//
//  MyProfileAssembly.swift
//  mylost
//
//  Created by Nato Egnatashvili on 01.09.21.
//

import Swinject

class MyProfileAssembly: UIAssembly {
    private let userID: Int
    private let bearerToken: String
    init(userID: Int,
         bearerToken: String) {
        self.userID = userID
        self.bearerToken = bearerToken
    }
    
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
            let presenter = MyProfilePresenterImpl(router: resolver.resolve(MyProfileRouterImpl.self)!,
                                                   userID: self.userID,
                                                   bearerToken: self.bearerToken, 
                                                   userInfoGateway: resolver.resolve(UserInfoGatewayImpl.self)!,
                                                   userInfoBearerGateway: resolver.resolve(UserInfoBearerGatewayImpl.self)!,
                                                   statementGateway: resolver.resolve(StatementGatewayImpl.self)!)
            return presenter
        }
        
        container.register(MyProfileRouterImpl.self) {_ in
            return MyProfileRouterImpl()
        }
    }
}
