//
//  SignInRouterMock.swift
//  mylostTests
//
//  Created by Nato Egnatashvili on 05.09.21.
//

import Foundation

@testable import mylost

class SignInRouterMock: SignInRouter {
    var controller: SignInViewController?
    var changeToUserHappen: Bool = false
    
    func attach(controller: SignInViewController) {
        self.controller = controller
    }
    
    func changeToUser() {
        changeToUserHappen = true
    }
    
}
