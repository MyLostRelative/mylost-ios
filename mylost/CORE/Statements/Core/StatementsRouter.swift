//  
//  StatementsRouter.swift
//  mylost
//
//  Created by Nato Egnatashvili on 6/21/21.
//

import Foundation

protocol StatementsRouter {
    
}

class StatementsRouterImpl: StatementsRouter {
    
    private weak var controller: StatementsController?
    
    init(_ controller: StatementsController?) {
        self.controller = controller
    }
    
}
