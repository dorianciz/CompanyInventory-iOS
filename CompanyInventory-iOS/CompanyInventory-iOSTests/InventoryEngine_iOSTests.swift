//
//  InventoryEngine_iOSTests.swift
//  CompanyInventory-iOSTests
//
//  Created by Dorian Cizmar on 4/15/18.
//  Copyright © 2018 Dorian Cizmar. All rights reserved.
//

import XCTest
@testable import CompanyInventory_iOS

class InventoryEngine_iOSTests: XCTestCase {
    
    var inventoryEngine: InventoryEngineProtocol!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        inventoryEngine = FirebaseInventoryEngine()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        inventoryEngine = nil
        super.tearDown()
    }
    
    func testAddInventorySuccessfully() {
        // 1. Given
        let item = Item()
        item.itemId = "testId"
        item.name = "Table"

        let item2 = Item()
        item2.itemId = "testId2"
        item2.name = "Table 2"

        let item3 = Item()
        item3.itemId = "testId3"
        item3.name = "Table 3"

        let item4 = Item()
        item4.itemId = "testId4"
        item4.name = "Table 4"

        let itemByDate = InventoryItemByDate()
        itemByDate.id = "SomeId"
        itemByDate.date = Date()
        itemByDate.items?.append(item)
        itemByDate.items?.append(item2)
        itemByDate.items?.append(item3)

        let itemByDate2 = InventoryItemByDate()
        itemByDate2.id = "SomeId2"
        itemByDate2.date = Date()
        itemByDate2.items?.append(item3)
        itemByDate2.items?.append(item4)

        let inventoryToSave = Inventory()
        inventoryToSave.inventoryId = "id1"
        inventoryToSave.name = "Some name"
        inventoryToSave.descriptionText = "Desc text"
        inventoryToSave.items?.append(itemByDate)
        inventoryToSave.items?.append(itemByDate2)
        
        var responseCode: Response?
        let promise = expectation(description: "Response received")
        
        // 2. When
        inventoryEngine.createInventory(withInventory: inventoryToSave, withCompletion: { (response) in
            responseCode = response
            
            promise.fulfill()
        })
    
        waitForExpectations(timeout: 5, handler: nil)
        
        // 3. Then
        XCTAssertEqual(responseCode!, Response.success)
        
    }
    
    func testGetInventoriesSuccessfully() {
        // 1. Given
        var resultInventories: [Inventory]?
        let countOfInventories = 1
        
        // 2. When
        inventoryEngine.getAllInventories { (response, inventories) in
            resultInventories = inventories
        }
        
        // 3. Then
        XCTAssertNotNil(resultInventories)
        XCTAssertEqual(resultInventories!.count, countOfInventories)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
