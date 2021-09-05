//  
//  MyLostHomeRouter.swift
//  mylost
//
//  Created by Nato Egnatashvili on 6/21/21.
//

import Foundation

protocol MyLostHomeRouter {
    func move2UserDetails()
}

class MyLostHomeRouterImpl: MyLostHomeRouter {
    
    private weak var controller: MyLostHomeController?
    
    init(_ controller: MyLostHomeController?) {
        self.controller = controller
    }
    
    func move2UserDetails() {
    }
}
