//
//  BlogDetailsRouter.swift
//  mylost
//
//  Created by Nato Egnatashvili on 05.09.21.
//
import Foundation

protocol BlogDetailsRouter {
    func attach(controller: BlogDetailsViewController)
    func backToBlogs()
}

class BlogDetailsRouterImpl: BlogDetailsRouter {
    
    private weak var controller: BlogDetailsViewController?
    
    func attach(controller: BlogDetailsViewController) {
        self.controller = controller
    }
    
    func backToBlogs() {
        self.controller?.navigationController?.viewControllers.removeLast()
    }
}
