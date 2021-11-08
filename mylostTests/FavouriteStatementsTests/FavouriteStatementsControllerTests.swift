//
//  FavouriteStatementsControllerTests.swift
//  mylostTests
//
//  Created by Nato Egnatashvili on 05.11.21.
//

import XCTest
@testable import mylost

class FavouriteStatementsControllerTests: XCTestCase {

    var controller: FavouriteStatementsController!
    var presenter: FavouriteStatementsPresenterMock!
    
    override func setUp() {
         controller = FavouriteStatementsController()
        presenter = FavouriteStatementsPresenterMock()
        controller.presenter = presenter
    }
    
    func testViewDidLoad() {
        controller.viewDidLoad()
        XCTAssertTrue(presenter.viewDidLoadHappen == true)
    }

    func testAttach() {
        presenter.attach(view: controller)
        XCTAssertTrue(controller.debugDescription == presenter.controller.debugDescription)
    }
}
