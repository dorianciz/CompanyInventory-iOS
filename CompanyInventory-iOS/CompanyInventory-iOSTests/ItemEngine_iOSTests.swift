//
//  ItemEngine_iOSTests.swift
//  CompanyInventory-iOSTests
//
//  Created by Dorian Cizmar on 2/16/18.
//  Copyright © 2018 Dorian Cizmar. All rights reserved.
//

import XCTest
@testable import CompanyInventory_iOS

class ItemEngine_iOSTests: XCTestCase {

    var itemEngine: ItemEngineProtocol!
    
    override func setUp() {
        super.setUp()
        itemEngine = FirebaseItemEngine()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        itemEngine = nil
    }
    
    func testUserCreatesItemAndSaveToDatabaseAndFirebaseSuccessfully() {
        // 1. Given
        let item = Item()
        item.itemId = "Id"
        var responseCode: Response?
        let promise = expectation(description: "Response received")
        
        // 2. When
        itemEngine.createItem(withItem: item, withCompletion: { (response) in
            responseCode = response
            
            promise.fulfill()
        })
        
        waitForExpectations(timeout: 5, handler: nil)
        
        // 3. Then
        XCTAssertEqual(responseCode!, Response.success)
    }
    
    func testUserHasFetchedItemsSuccessfully() {
        // 1. Given
        let promise = expectation(description: "Completion handler invoked")
        var items : [Item]?
        var resCode: Response?
        
        // 2. When
        itemEngine.getAllItems(withCompletion: { (data, responseCode) in
            items = data
            resCode = responseCode
            
            promise.fulfill()
        })
        
        waitForExpectations(timeout: 5, handler: nil)
        
        // 3. Then
        XCTAssertNotNil(items)
        XCTAssertEqual(resCode!, Response.success)
        XCTAssertNotEqual(items!.count, 0)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
