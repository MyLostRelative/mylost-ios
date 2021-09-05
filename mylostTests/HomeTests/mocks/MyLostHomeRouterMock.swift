//
//  MyLostHomeRouterMock.swift
//  mylostTests
//
//  Created by Nato Egnatashvili on 04.09.21.
//

import XCTest

@testable import mylost

class MyLostHomeRouterMock: MyLostHomeRouter {
    var move2UserHappend: Bool = false
    
    func move2UserDetails() {
        move2UserHappend = true
    }
    
}
