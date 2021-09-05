//  
//  PostCreateRouter.swift
//  mylost
//
//  Created by Nato Egnatashvili on 05.09.21.
//

import Foundation

protocol PostCreateRouter {
    func moveToback()
    func attach(controller: PostCreateViewController)
}

class PostCreateRouterImpl: PostCreateRouter {
    
    private weak var controller: PostCreateViewController?
    
    func attach(controller: PostCreateViewController) {
        self.controller = controller
    }
    
    func moveToback() {
        self.controller?.navigationController?.viewControllers.removeLast()
    }
    
}
