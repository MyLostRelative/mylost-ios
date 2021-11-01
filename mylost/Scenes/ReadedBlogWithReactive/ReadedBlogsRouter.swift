//  
//  BlogDetailsReactiveRouter.swift
//  mylost
//
//  Created by Nato Egnatashvili on 26.10.21.
//

import Foundation

protocol ReadedBlogsRouter {
    func attach(controller: ReadedBlogsController)
}

class ReadedBlogsRouterImpl: ReadedBlogsRouter {
    
    private weak var controller: ReadedBlogsController?
    
    func attach(controller: ReadedBlogsController) {
        self.controller = controller
    }
    
}

