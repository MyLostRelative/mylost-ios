//
//  NetworkTests.swift
//  mylostTests
//
//  Created by Nato Egnatashvili on 05.09.21.
//

import XCTest
@testable import mylost

class NetworkTests: XCTestCase {

    
    override func setUp() {
    }
    
    func testLogin() {
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
    
    func testBlogs() {
        let expectation = XCTestExpectation(description: "catch post request")
            
            let url = URL(string: "https://mylost-api.herokuapp.com/blogs")!
            
            URLSession.shared.dataTask(with: url) { (data, _, _) in
                XCTAssertNotNil(data, "No data was downloaded.")
                // Fulfill the expectation to indicate that the background task has finished successfully.
                expectation.fulfill()
            }.resume()
            
            // Wait until the expectation is fulfilled, with a timeout of 10 seconds.
            wait(for: [expectation], timeout: 10.0)
    }

}


