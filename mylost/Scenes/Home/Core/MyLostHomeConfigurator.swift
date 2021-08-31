//  
//  MyLostHomeConfigurator.swift
//  mylost
//
//  Created by Nato Egnatashvili on 6/21/21.
//

import Foundation

protocol MyLostHomeConfigurator {
    func configure(_ controller: MyLostHomeController)
}

class MyLostHomeConfiguratorImpl: MyLostHomeConfigurator {
    
    func configure(_ controller: MyLostHomeController) {
        let router: MyLostHomeRouter = MyLostHomeRouterImpl(controller)
        let gateway = StatementGatewayImpl()
        
        let presenter: MyLostHomePresenter = MyLostHomePresenterImpl(
            view: controller,
            statementsGateway: gateway,
            router: router
        )
        
        controller.mypresenter = presenter
    }
    
}
