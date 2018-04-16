//
//  CIUserDatabase_iOSTests.swift
//  CompanyInventory-iOSTests
//
//  Created by Dorian Cizmar on 4/14/18.
//  Copyright © 2018 Dorian Cizmar. All rights reserved.
//

import XCTest
@testable import CompanyInventory_iOS

class CIUserDatabase_iOSTests: XCTestCase {

    var ciUserDatabase: CIUserDatabaseProtocol!
    
    override func setUp() {
        super.setUp()
        ciUserDatabase = CIUserRealmDatabase()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        ciUserDatabase = nil
    }
    
    func testDeleteCurrentUser() {
        // 1. Given
        
        
        // 2. When
        ciUserDatabase.deleteCurrentUser()
        
        // 3. Then
        
    }
    
    func testGetUserByIdNotSuccessfully() {
        // 1. Given
        let userToSave = CIUser()
        userToSave.username = "testuser2@companyInventory.com"
        userToSave.name = "Test"
        userToSave.surname = "User 23333333"
        userToSave.uid = "8v2NNBC7Mcf7Vvwpt6iaZiPGIpk2"
        userToSave.photoName = "photoName.png"
        
        
        // 2. When
        let result: CIUser? = ciUserDatabase.getUserByUid("8v2NNBC7Mcf7Vvwpt6iaZiPGIpk2")
        
        // 3. Then
        XCTAssertNil(result)
    }
    
    func testUserIsSavedSuccessfully() {
        // 1. Given
        let userToSave = CIUser()
        userToSave.username = "testuser2@companyInventory.com"
        userToSave.name = "Test"
        userToSave.surname = "User 2333333333"
        userToSave.uid = "8v2NNBC7Mcf7Vvwpt6iaZiPGIpk2"
        userToSave.photoName = "photoName.png"
        
        
        // 2. When
        let result: Bool? = ciUserDatabase.saveCurrentUser(userToSave)
        let resultUser: CIUser? = ciUserDatabase.getUserByUid("8v2NNBC7Mcf7Vvwpt6iaZiPGIpk2")
        
        // 3. Then
        XCTAssertNotNil(result)
        XCTAssertTrue(result!)
        XCTAssertNotNil(resultUser)
        XCTAssertTrue(resultUser!.uid!.elementsEqual("8v2NNBC7Mcf7Vvwpt6iaZiPGIpk2"))
    }
    
    func testCurrentUser() {
        // 1. Given
        let expectedUid = "8v2NNBC7Mcf7Vvwpt6iaZiPGIpk2"
        var resultUser: CIUser?
        
        
        // 2. When
        resultUser = ciUserDatabase.getCurrentUser()
        
        // 3. Then
        XCTAssertNotNil(resultUser)
        XCTAssertTrue(resultUser!.uid!.elementsEqual(expectedUid))
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
