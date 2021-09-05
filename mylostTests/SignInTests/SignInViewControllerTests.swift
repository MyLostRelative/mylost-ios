//
//  SignInViewControllerTests.swift
//  mylostTests
//
//  Created by Nato Egnatashvili on 05.09.21.
//

import XCTest
@testable import mylost

class SignInViewControllerTests: XCTestCase {

    var controller: SignInViewController!
    var presenter: SignInPresenterMock!
    
    override func setUp() {
         controller = SignInViewController()
        presenter = SignInPresenterMock()
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
