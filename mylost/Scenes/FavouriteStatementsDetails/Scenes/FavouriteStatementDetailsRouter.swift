//  
//  FavouriteStatementDetailsRouter.swift
//  mylost
//
//  Created by Nato Egnatashvili on 19.10.21.
//

import Foundation

protocol FavouriteStatementDetailsRouter {
    func attach(controller: FavouriteStatementDetailsController)
}

class FavouriteStatementDetailsRouterImpl: FavouriteStatementDetailsRouter {
    
    private weak var controller: FavouriteStatementDetailsController?
    
    func attach(controller: FavouriteStatementDetailsController) {
        self.controller = controller
    }
    
}

