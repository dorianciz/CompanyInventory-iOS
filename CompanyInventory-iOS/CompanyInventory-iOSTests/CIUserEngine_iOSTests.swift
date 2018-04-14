//
//  CIUserEngine_iOSTests.swift
//  CompanyInventory-iOSTests
//
//  Created by Dorian Cizmar on 2/16/18.
//  Copyright © 2018 Dorian Cizmar. All rights reserved.
//

import XCTest
@testable import CompanyInventory_iOS

class CIUserEngine_iOSTests: XCTestCase {
    
    var ciUserEngine: CIUserEngineProtocol!
    
    
    override func setUp() {
        super.setUp()
        ciUserEngine = FirebaseCIUserEngine()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        ciUserEngine = nil
        super.tearDown()
    }
    
    func testUserSavedOnFirebaseSuccessfully() {
        // 1. Given
        let userToSave = CIUser()
        userToSave.username = "testuser2@companyInventory.com"
        userToSave.name = "Test"
        userToSave.surname = "User 2"
        userToSave.uid = "8v2NNBC7Mcf7Vvwpt6iaZiPGIpk2"
        userToSave.photoName = "photoName.png"
        
        let promise = expectation(description: "Sign in callback invoked")
        var resCode: Response?
        
        
        // 2. When
        ciUserEngine.saveUser(user: userToSave, withCompletion: { (responseCode) in
            resCode = responseCode
            
            promise.fulfill()
        })
        
        waitForExpectations(timeout: 5, handler: nil)
        
        // 3. Then
        XCTAssertNotNil(resCode)
        XCTAssertEqual(resCode!, Response.success)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
