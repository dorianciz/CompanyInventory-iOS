//
//  LoginBrain_iOSTests.swift
//  CompanyInventory-iOSTests
//
//  Created by Dorian Cizmar on 4/13/18.
//  Copyright © 2018 Dorian Cizmar. All rights reserved.
//

import XCTest
@testable import CompanyInventory_iOS

class LoginBrain_iOSTests: XCTestCase {
    
    var loginBrain: LoginBrain!
    
    override func setUp() {
        super.setUp()
        loginBrain = LoginBrain()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        loginBrain = nil
    }
    
    func testUserEnterInvalidEmailAddress() {
        // 1. Given
        let email = "test.com"
        var booleanResult: Bool?
        
        // 2. When
        booleanResult = loginBrain.isEmailValid(email: email)
        
        // 3. Then
        XCTAssertNotNil(booleanResult)
        XCTAssert(!booleanResult!)
    }
    
    func testUserEnterValidEmailAddress() {
        // 1. Given
        let email = "test@yahoo.com"
        var booleanResult: Bool?
        
        // 2. When
        booleanResult = loginBrain.isEmailValid(email: email)
        
        // 3. Then
        XCTAssertNotNil(booleanResult)
        XCTAssert(booleanResult!)
    }
    
    func testUserEnterNilEmailAddress() {
        // 1. Given
        var booleanResult: Bool?
        
        // 2. When
        booleanResult = loginBrain.isEmailValid(email: nil)
        
        // 3. Then
        XCTAssertNil(booleanResult)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
