//  
//  StatementsConfigurator.swift
//  mylost
//
//  Created by Nato Egnatashvili on 6/21/21.
//

import Foundation
import Core

protocol StatementsConfigurator {
    func configure(_ controller: StatementsController)
}

class StatementsConfiguratorImpl: StatementsConfigurator {
    private let statementsAndBlogsAdapter: StatementsAndBlogsAdapter
    
    init(statementsAndBlogsAdapter: StatementsAndBlogsAdapter) {
        self.statementsAndBlogsAdapter = statementsAndBlogsAdapter
    }
    
    func configure(_ controller: StatementsController) {
        let router: StatementsRouter = StatementsRouterImpl(controller)
        let gateway = BlogGatewayImpl()
        let presenter: StatementsPresenter = StatementsPresenterImpl(
            view: controller,
            router: router,
            blogGateway: gateway,
            statementsAndBlogsAdapter: statementsAndBlogsAdapter
        )
        
        controller.statementPresenter = presenter
    }
    
}
