//
//  MyLostHomePresenterTest.swift
//  mylostTests
//
//  Created by Nato Egnatashvili on 04.09.21.
//

import XCTest
@testable import mylost

class MyLostHomePresenterTest: XCTestCase {

    var controller: MyLostHomeController!
    var presenter: MyLostHomePresenterImpl!
    var router: MyLostHomeRouterMock!
    
    override func setUp() {
         controller = MyLostHomeController()
        router = MyLostHomeRouterMock()
        presenter = MyLostHomePresenterImpl(view: controller,
                                            statementsGateway: StatementGatewayImpl(),
                                            router: router)
        controller.mypresenter = presenter
    }
    
    func testViewDidLoad() {
        let expectation = XCTestExpectation(description: "Download apple.com home page")
            
            let url = URL(string: "https://mylost-api.herokuapp.com/ads")!
            
            URLSession.shared.dataTask(with: url) { (data, _, _) in
                XCTAssertNotNil(data, "No data was downloaded.")
                // Fulfill the expectation to indicate that the background task has finished successfully.
                expectation.fulfill()
            }.resume()
            
            // Wait until the expectation is fulfilled, with a timeout of 10 seconds.
            wait(for: [expectation], timeout: 10.0)
    }

}

