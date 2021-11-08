//
//  FavouriteStatementsRouterMock.swift
//  mylostTests
//
//  Created by Nato Egnatashvili on 05.11.21.
//

import Foundation

@testable import mylost

class FavouriteStatementsRouterMock: FavouriteStatementsRouter {
    
    
    var controller: FavouriteStatementsController?
    var moveToBackHappen: Bool = false
    
    func attach(controller: FavouriteStatementsController) {
        self.controller = controller
    }
    
    func moveToback() {
        moveToBackHappen = true
    }
    
}
