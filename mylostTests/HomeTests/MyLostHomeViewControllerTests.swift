//
//  MyLostHomeViewControllerTests.swift
//  mylostTests
//
//  Created by Nato Egnatashvili on 04.09.21.
//

import XCTest
@testable import mylost

class MyLostHomeViewControllerTests: XCTestCase {

    var controller: MyLostHomeController!
    var presenter: MyLostHomePresenterMock!
    
    override func setUp() {
         controller = MyLostHomeController()
        presenter = MyLostHomePresenterMock()
        controller.mypresenter = presenter
    }
    
    func testViewDidLoad() {
        controller.viewDidLoad()
        XCTAssertTrue(presenter.viewDidLoadHappen == true)
    }

}
