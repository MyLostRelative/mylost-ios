//  
//  FilterDetailsConfigurator.swift
//  mylost
//
//  Created by Nato Egnatashvili on 06.09.21.
//

import Swinject

class FilterDetailsAssembly: UIAssembly {
    private let delegate: FilterDetailsPresenterDelegate?
    init(delegate: FilterDetailsPresenterDelegate?) {
        self.delegate = delegate
    }
    
    func assemble(container: Container) {
        container.register(FilterDetailsViewController.self) {resolver in
            let controller  = FilterDetailsViewController()
            let presenter = resolver.resolve(FilterDetailsPresenterImpl.self)
            controller.presenter = presenter
            return controller
        }.initCompleted { resolver, vc in
            resolver.resolve(FilterDetailsRouterImpl.self)?.attach(controller: vc)
            resolver.resolve(FilterDetailsPresenterImpl.self)?.attach(view: vc)
        }
        
        container.register(FilterDetailsPresenterImpl.self) {resolver in
            let presenter = FilterDetailsPresenterImpl(router: resolver.resolve(FilterDetailsRouterImpl.self)!, delegate: self.delegate)
            return presenter
        }
        
        container.register(FilterDetailsRouterImpl.self) {resolver in
            return FilterDetailsRouterImpl()
        }
    }
}

