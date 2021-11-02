//  
//  FavouriteStatementsConfigurator.swift
//  mylost
//
//  Created by Nato Egnatashvili on 27.09.21.
//

import Swinject
import RxRelay
import Core

class FavouriteStatementsAssembly: UIAssembly {
    let favouriteStatements: BehaviorRelay<[Statement]>
    init(favouriteStatements: BehaviorRelay<[Statement]>) {
        self.favouriteStatements = favouriteStatements
    }
    
    func assemble(container: Container) {
        container.register(FavouriteStatementsController.self) {resolver in
            let controller  = FavouriteStatementsController()
            let presenter = resolver.resolve(FavouriteStatementsPresenterImpl.self)
            controller.presenter = presenter
            return controller
        }.initCompleted { resolver, vc in
            resolver.resolve(FavouriteStatementsPresenterImpl.self)?.attach(view: vc)
            resolver.resolve(FavouriteStatementsRouterImpl.self)?.attach(controller: vc)
        }
        
        container.register(FavouriteStatementsPresenterImpl.self) {resolver in
            let presenter = FavouriteStatementsPresenterImpl(
                router: resolver.resolve(FavouriteStatementsRouterImpl.self)!,
                favouriteStatements: self.favouriteStatements)
            return presenter
        }
        
        container.register(FavouriteStatementsRouterImpl.self) {_ in
            return FavouriteStatementsRouterImpl()
        }
    }
}
