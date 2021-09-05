//
//  SignInPresenterMock.swift
//  mylostTests
//
//  Created by Nato Egnatashvili on 05.09.21.
//

import XCTest

@testable import mylost

class SignInPresenterMock: SignInPresenter {
    
    var viewDidLoadHappen: Bool = false
    var attachHappen: Bool = false
    var controller: SignInView?
    
    func attach(view: SignInView) {
        controller = view
        attachHappen = true
    }
    
    func viewDidLoad() {
        viewDidLoadHappen = true
    }
    
}

