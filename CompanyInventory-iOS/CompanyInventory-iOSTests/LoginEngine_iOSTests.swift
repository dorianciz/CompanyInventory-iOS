//
//  LoginEngine_iOSTests.swift
//  CompanyInventory-iOSTests
//
//  Created by Dorian Cizmar on 2/16/18.
//  Copyright © 2018 Dorian Cizmar. All rights reserved.
//

import XCTest
@testable import CompanyInventory_iOS

class LoginEngine_iOSTests: XCTestCase {
    
    var loginEngine: LoginEngineProtocol!
    
    override func setUp() {
        super.setUp()
        loginEngine = FirebaseLoginEngine()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        loginEngine = nil
        super.tearDown()
    }
    
    func testUserLoggedInSuccessfully() {
        // 1. Given
        let username = "testuser3@companyinventory.com"
        let password = "Test123"
        let promise = expectation(description: "Login callback invoked")
        var resCode: Response?
        
        
        // 2. When
        loginEngine.loginUser(withUsername: username, withPassword: password, withCompletion: { (responseCode, ciUser) in
            resCode = responseCode
            
            promise.fulfill()
        })
        
        waitForExpectations(timeout: 5, handler: nil)
        
        // 3. Then
        XCTAssertEqual(resCode!, Response.success)
    }
    
    func testUserLoggedInWithWrongPassword() {
        // 1. Given
        let username = "testuser@companyInventory.com"
        let password = "WrongPass"
        let promise = expectation(description: "Login callback invoked")
        var resCode: Response?
        
        
        // 2. When
        loginEngine.loginUser(withUsername: username, withPassword: password, withCompletion: { (responseCode, ciUser) in
            resCode = responseCode
            
            promise.fulfill()
        })
        
        waitForExpectations(timeout: 5, handler: nil)
        
        // 3. Then
        XCTAssertEqual(resCode!, Response.error)
    }
    
    func testUserSignedInSuccessfully() {
        // 1. Given
        let username = "testuser4@companyinventory.com"
        let password = "Test123"
        let promise = expectation(description: "Sign in callback invoked")
        var resCode: Response?
        var newUserResult: CIUser?
        
        // 2. When
        loginEngine.signInUser(withUsername: username, withPassword: password, withCompletion: { (ciUser, responseCode) in
            resCode = responseCode
            newUserResult = ciUser
            
            promise.fulfill()
        })
        
        waitForExpectations(timeout: 5, handler: nil)
        
        // 3. Then
        XCTAssertEqual(resCode!, Response.success)
        XCTAssertNotNil(newUserResult)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
