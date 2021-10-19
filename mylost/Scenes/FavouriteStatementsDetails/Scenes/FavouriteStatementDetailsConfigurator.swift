//  
//  FavouriteStatementDetailsConfigurator.swift
//  mylost
//
//  Created by Nato Egnatashvili on 19.10.21.
//

import Swinject
import RxRelay

class FavouriteStatementsDetailsAssembly: UIAssembly {
    let favouriteStatements: BehaviorRelay<[Statement]>
    init(favouriteStatements: BehaviorRelay<[Statement]>) {
        self.favouriteStatements = favouriteStatements
    }
    
    func assemble(container: Container) {
        container.register(FavouriteStatementDetailsController.self) {resolver in
            let controller  = FavouriteStatementDetailsController()
            let presenter = resolver.resolve(FavouriteStatementDetailsPresenterImpl.self)
            controller.presenter = presenter
            return controller
        }.initCompleted { resolver, vc in
            resolver.resolve(FavouriteStatementDetailsPresenterImpl.self)?.attach(view: vc)
            resolver.resolve(FavouriteStatementDetailsRouterImpl.self)?.attach(controller: vc)
        }
        
        container.register(FavouriteStatementDetailsPresenterImpl.self) {resolver in
            let presenter = FavouriteStatementDetailsPresenterImpl(
                router: resolver.resolve(FavouriteStatementDetailsRouterImpl.self)!,
                favouriteStatements: self.favouriteStatements)
            return presenter
        }
        
        container.register(FavouriteStatementDetailsRouterImpl.self) {resolver in
            return FavouriteStatementDetailsRouterImpl()
        }
    }
}

