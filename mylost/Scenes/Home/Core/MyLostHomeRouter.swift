//  
//  MyLostHomeRouter.swift
//  mylost
//
//  Created by Nato Egnatashvili on 6/21/21.
//

import Foundation

protocol MyLostHomeRouter {
    func move2UserDetails(guestUserID: Int)
}

class MyLostHomeRouterImpl: MyLostHomeRouter {
    
    private weak var controller: MyLostHomeController?
    
    init(_ controller: MyLostHomeController?) {
        self.controller = controller
    }
    
    func move2UserDetails(guestUserID: Int) {
        guard let vc = DIAssembly(uiAssemblies: [ContactDetailsAssembly(guestUserID: guestUserID)],
                                  networkAssemblies: [UserInfoetworkAssembly()])
            .resolver
                .resolve(ContactDetailsViewController.self) else { return }
        
        self.controller?.navigationController?.pushViewController(vc, animated: true)
        
    }
}
