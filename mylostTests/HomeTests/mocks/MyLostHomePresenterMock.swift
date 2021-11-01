//
//  MyLostHomePresenterMock.swift
//  mylostTests
//
//  Created by Nato Egnatashvili on 04.09.21.
//

import XCTest

@testable import mylost

class MyLostHomePresenterMock: MyLostHomePresenter {
    
    
     var viewDidLoadHappen: Bool = false
    var viewWillAppearHappen: Bool = false
    func viewDidLoad() {
        viewDidLoadHappen = true
    }
    
    func viewWillAppear() {
        viewWillAppearHappen = true
    }
    
}


