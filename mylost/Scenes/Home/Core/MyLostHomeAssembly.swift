//  
//  MyLostHomeConfigurator.swift
//  mylost
//
//  Created by Nato Egnatashvili on 6/21/21.
//

import Swinject
import RxRelay
import Core

class MyLostHomeAssembly: UIAssembly {
    private let statementsAndBlogsAdapter: StatementsAndBlogsAdapter
    
    init(statementsAndBlogsAdapter: StatementsAndBlogsAdapter) {
        self.statementsAndBlogsAdapter = statementsAndBlogsAdapter
    }
    
    func assemble(container: Container) {
        container.register(MyLostHomeController.self) {resolver in
            let controller  = MyLostHomeController()
            let presenter = resolver.resolve(MyLostHomePresenterImpl.self)
            controller.mypresenter = presenter
            return controller
        }.initCompleted { resolver, vc in
            resolver.resolve(MyLostHomePresenterImpl.self)?.attach(view: vc)
            resolver.resolve(MyLostHomeRouterImpl.self)?.attach(controller: vc)
        }
        
        container.register(MyLostHomePresenterImpl.self) {resolver in
            let presenter = MyLostHomePresenterImpl(
                statementsGateway: resolver.resolve(StatementGatewayImpl.self)!,
                router: resolver.resolve(MyLostHomeRouterImpl.self)!,
                statementsAndBlogsAdapter: self.statementsAndBlogsAdapter)
            return presenter
        }
        
        container.register(MyLostHomeRouterImpl.self) {_ in
            return MyLostHomeRouterImpl()
        }
    }
}
