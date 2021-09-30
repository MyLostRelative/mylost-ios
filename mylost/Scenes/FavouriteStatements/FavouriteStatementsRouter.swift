//  
//  FavouriteStatementsRouter.swift
//  mylost
//
//  Created by Nato Egnatashvili on 27.09.21.
//

import Foundation

protocol FavouriteStatementsRouter {
    func moveToback()
    func attach(controller: FavouriteStatementsController)
}

class FavouriteStatementsRouterImpl: FavouriteStatementsRouter {
    
    private weak var controller: FavouriteStatementsController?
    
    func attach(controller: FavouriteStatementsController) {
        self.controller = controller
    }
    
    func moveToback() {
        self.controller?.navigationController?.viewControllers.removeLast()
    }
    
}
