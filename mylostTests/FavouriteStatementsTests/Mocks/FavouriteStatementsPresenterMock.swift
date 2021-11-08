//
//  FavouriteStatementsPresenterMock.swift
//  mylostTests
//
//  Created by Nato Egnatashvili on 05.11.21.
//

import XCTest

@testable import mylost

class FavouriteStatementsPresenterMock: FavouriteStatementsPresenter {
    
    var viewDidLoadHappen: Bool = false
    var attachHappen: Bool = false
    var controller: FavouriteStatementsView?
    
    func attach(view: FavouriteStatementsView) {
        controller = view
        attachHappen = true
    }
    
    func viewDidLoad() {
        viewDidLoadHappen = true
    }
    
}
