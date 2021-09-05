//  
//  StatementsRouter.swift
//  mylost
//
//  Created by Nato Egnatashvili on 6/21/21.
//

import Foundation

protocol StatementsRouter {
    func move2BlogDetails(blog: Blog)
}

class StatementsRouterImpl: StatementsRouter {
    
    private weak var controller: StatementsController?
    
    init(_ controller: StatementsController?) {
        self.controller = controller
    }
    
    func move2BlogDetails(blog: Blog) {
        guard let vc = DIAssembly.init(uiAssemblies: [BlogDetailsAssembly(blog: blog)],
                        networkAssemblies: [])
            .resolver
                .resolve(BlogDetailsViewController.self) else { return }
        self.controller?.navigationController?.pushViewController(vc, animated: true)
    }
    
}
