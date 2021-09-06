//  
//  FilterDetailsRouter.swift
//  mylost
//
//  Created by Nato Egnatashvili on 06.09.21.
//

import Foundation

protocol FilterDetailsRouter {
    func moveToback()
    func attach(controller: FilterDetailsViewController)
}

class FilterDetailsRouterImpl: FilterDetailsRouter {
    
    private weak var controller: FilterDetailsViewController?
    
    func attach(controller: FilterDetailsViewController) {
        self.controller = controller
    }
    
    func moveToback() {
        self.controller?.navigationController?.viewControllers.removeLast()
    }
    
}
