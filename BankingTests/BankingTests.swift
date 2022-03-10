//
//  BankingTests.swift
//  BankingTests
//
//  Created by Nico Christian on 09/03/22.
//

import XCTest
@testable import Banking

class BankingTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testLoginSuccess() throws {
        if let data = """
        {
            "status": "success",
            "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2MTZlNzNlMDYyYWY0ZGQ5YmMyYzYxMWQiLCJ1c2VybmFtZSI6InRlc3QiLCJhY2NvdW50Tm8iOiIyOTcwLTExMS0zNjQ4IiwiaWF0IjoxNjQ2OTA4MTIxLCJleHAiOjE2NDY5MTg5MjF9.Au9xlHuheNej-5mhCeOYepHSnu9LTYoVaTY2yr74F0U",
            "username": "test",
            "accountNo": "2970-111-3648"
        }
        """.data(using: .utf8) {
            let authenticationResponse = try JSONDecoder().decode(AuthenticationResponse.self, from: data)
            
            XCTAssertEqual(authenticationResponse.status, "success")
            XCTAssertEqual(authenticationResponse.token, "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2MTZlNzNlMDYyYWY0ZGQ5YmMyYzYxMWQiLCJ1c2VybmFtZSI6InRlc3QiLCJhY2NvdW50Tm8iOiIyOTcwLTExMS0zNjQ4IiwiaWF0IjoxNjQ2OTA4MTIxLCJleHAiOjE2NDY5MTg5MjF9.Au9xlHuheNej-5mhCeOYepHSnu9LTYoVaTY2yr74F0U")
            XCTAssertEqual(authenticationResponse.username, "test")
            XCTAssertEqual(authenticationResponse.accountNo, "2970-111-3648")
            XCTAssertNil(authenticationResponse.error)
        }
    }
    
    func testLoginInavlidCredential() throws {
        if let data = """
        {
            "status": "failed",
            "error": "invalid login credential"
        }
        """.data(using: .utf8) {
            let response = try JSONDecoder().decode(AuthenticationResponse.self, from: data)
            XCTAssertEqual(response.status, "failed")
            XCTAssertEqual(response.error, "invalid login credential")
            XCTAssertNil(response.token)
            XCTAssertNil(response.username)
            XCTAssertNil(response.accountNo)
        }
    }
}
