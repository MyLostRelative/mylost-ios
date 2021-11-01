//
//  MyLostHomeRouterMock.swift
//  mylostTests
//
//  Created by Nato Egnatashvili on 04.09.21.
//

import XCTest
import RxSwift
import RxRelay

@testable import mylost

class MyLostHomeRouterMock: MyLostHomeRouter {
    func move2UserDetails(guestUserID: Int, guestImgUrl: String?) {
        
    }
    
    func move2Filter(delegate: FilterDetailsPresenterDelegate) {
        
    }
    
    func move2H() {
        
    }
    
    func move2Fav(favouriteStatements: BehaviorRelay<[Statement]>) {
        
    }
    
    var move2UserHappend: Bool = false
    
    func move2UserDetails() {
        move2UserHappend = true
    }
    
}
