//
//  SignInPresenterTests.swift
//  mylostTests
//
//  Created by Nato Egnatashvili on 05.09.21.
//

import XCTest
@testable import mylost
@testable import Core

class SignInPresenterTests: XCTestCase {

    var controller: SignInViewController!
    var presenter: SignInPresenter!
    var router: SignInRouterMock!
    
    override func setUp() {
         controller = SignInViewController()
        router = SignInRouterMock()
        presenter = SignInPresenterImpl(router: router,
                                        loginGateway: LoginGatewayImpl(),
                                        registrationGateway: RegistrationGatewayImpl())
        controller.presenter = presenter
    }
    
    func testViewDidLoad() {
        let expectation = XCTestExpectation(description: "catch post request")
            
            let url = URL(string: "https://mylost-api.herokuapp.com/users/login")!
            
            URLSession.shared.dataTask(with: url) { (data, _, _) in
                XCTAssertNotNil(data, "No data was downloaded.")
                // Fulfill the expectation to indicate that the background task has finished successfully.
                expectation.fulfill()
            }.resume()
            
            // Wait until the expectation is fulfilled, with a timeout of 10 seconds.
            wait(for: [expectation], timeout: 10.0)
    }
    
    func testmoveToRegistration () {
        router.move2Registration()
        XCTAssertTrue(router.moveToRegistrationHappen, "registration Click")
    }
}
