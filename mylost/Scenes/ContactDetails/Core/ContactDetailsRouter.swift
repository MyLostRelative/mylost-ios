//  
//  ContactDetailsRouter.swift
//  mylost
//
//  Created by Nato Egnatashvili on 06.09.21.
//

import Foundation

protocol ContactDetailsRouter {
    func moveToback()
    func attach(controller: ContactDetailsViewController)
}

class ContactDetailsRouterImpl: ContactDetailsRouter {
    
    private weak var controller: ContactDetailsViewController?
    
    func attach(controller: ContactDetailsViewController) {
        self.controller = controller
    }
    
    func moveToback() {
        self.controller?.navigationController?.viewControllers.removeLast()
    }
    
}
