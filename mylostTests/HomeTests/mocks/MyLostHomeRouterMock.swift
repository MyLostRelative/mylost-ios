//
//  MyLostHomeRouterMock.swift
//  mylostTests
//
//  Created by Nato Egnatashvili on 04.09.21.
//

import XCTest
import RxSwift
import RxRelay
import Core
@testable import mylost

class MyLostHomeRouterMock: MyLostHomeRouter {
    var viewAttachHappen = true
    var move2UserHappend: Bool = false
    var move2UserDetailsHappend: Bool = false
    var move2FilterHappen: Bool = false
    var move2FavHappend: Bool = false
    
    func move2UserDetails() {
        move2UserHappend = true
    }
    
    func attach(controller: MyLostHomeController) {
        viewAttachHappen = true
    }
    
    func move2UserDetails(guestUserID: Int, guestImgUrl: String?) {
        move2UserDetailsHappend = true
    }
    
    func move2Filter(delegate: FilterDetailsPresenterDelegate) {
        move2FilterHappen = true
    }
    
    func move2Fav(favouriteStatements: BehaviorRelay<[Statement]>) {
        move2FavHappend = true
    }
    
    
}
