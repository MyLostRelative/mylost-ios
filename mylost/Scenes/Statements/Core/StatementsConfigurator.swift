//  
//  StatementsConfigurator.swift
//  mylost
//
//  Created by Nato Egnatashvili on 6/21/21.
//

import Foundation

protocol StatementsConfigurator {
    func configure(_ controller: StatementsController)
}

class StatementsConfiguratorImpl: StatementsConfigurator {
    
    func configure(_ controller: StatementsController) {
        let router: StatementsRouter = StatementsRouterImpl(controller)
        
        let presenter: StatementsPresenter = StatementsPresenterImpl(
            view: controller,
            router: router
        )
        
        controller.statementPresenter = presenter
    }
    
}
