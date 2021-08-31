//  
//  RegistrationConfigurator.swift
//  Registration
//
//  Created by Nato Egnatashvili on 22.08.21.
//

import Foundation

protocol RegistrationConfigurator {
    func configure(_ controller: RegistrationController)
}

class RegistrationConfiguratorImpl: RegistrationConfigurator {
    
    func configure(_ controller: RegistrationController) {
        let router: RegistrationRouter = RegistrationRouterImpl(controller)
        
        let presenter: RegistrationPresenter = RegistrationPresenterImpl(
            view: controller,
            router: router
        )
        
        controller.presenter = presenter
    }
    
}
