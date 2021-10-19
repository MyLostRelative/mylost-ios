//
//  NetworkTests.swift
//  mylostTests
//
//  Created by Nato Egnatashvili on 05.09.21.
//

import XCTest
@testable import mylost

class NetworkTests: XCTestCase {
    var sut: URLSession!

    override func setUpWithError() throws {
      try super.setUpWithError()
      sut = URLSession(configuration: .default)
    }

    override func tearDownWithError() throws {
      sut = nil
      try super.tearDownWithError()
    }
    
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

    func testValidApiCallGetsHTTPStatusCode200() throws {
      // given
      let urlString =
        "https://mylost-api.herokuapp.com/blogs"
      let url = URL(string: urlString)!
      // 1
      let promise = expectation(description: "Status code: 200")

      // when
      let dataTask = sut.dataTask(with: url) { _, response, error in
        // then
        if let error = error {
          XCTFail("Error: \(error.localizedDescription)")
          return
        } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
          if statusCode == 200 {
            // 2
            promise.fulfill()
          } else {
            XCTFail("Status code: \(statusCode)")
          }
        }
      }
      dataTask.resume()
      // 3
      wait(for: [promise], timeout: 5)
    }
    
    func testApiCallCompletes() throws {
      // given
      let urlString = "https://mylost-api.herokuapp.com/blogs"
      let url = URL(string: urlString)!
      let promise = expectation(description: "Completion handler invoked")
      var statusCode: Int?
      var responseError: Error?

      // when
      let dataTask = sut.dataTask(with: url) { _, response, error in
        statusCode = (response as? HTTPURLResponse)?.statusCode
        responseError = error
        promise.fulfill()
      }
      dataTask.resume()
      wait(for: [promise], timeout: 5)

      // then
      XCTAssertNil(responseError)
      XCTAssertEqual(statusCode, 200)
    }
}


