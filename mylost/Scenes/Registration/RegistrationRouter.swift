//  
//  RegistrationRouter.swift
//  Registration
//
//  Created by Nato Egnatashvili on 22.08.21.
//

import Foundation

protocol RegistrationRouter {
    
}

class RegistrationRouterImpl: RegistrationRouter {
    
    private weak var controller: RegistrationController?
    
    init(_ controller: RegistrationController?) {
        self.controller = controller
    }
    
}
