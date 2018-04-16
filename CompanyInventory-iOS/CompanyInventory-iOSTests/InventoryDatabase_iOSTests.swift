//
//  InventoryDatabase_iOSTests.swift
//  CompanyInventory-iOSTests
//
//  Created by Dorian Cizmar on 4/14/18.
//  Copyright © 2018 Dorian Cizmar. All rights reserved.
//

import XCTest
import RealmSwift
@testable import CompanyInventory_iOS

class InventoryDatabase_iOSTests: XCTestCase {
    
    var inventoryDatabase: InventoryDatabaseProtocol!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        inventoryDatabase = InventoryRealmDatabase()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        inventoryDatabase = nil
    }
    
    func testSaveInventorySuccessfully() {
        // 1. Given
        let item = Item()
        item.itemId = "testId"
        item.name = "Table"
        
        let itemByDate = InventoryItemByDate()
        itemByDate.id = "SomeId"
        itemByDate.date = Date()
        itemByDate.items?.append(item)
        
        let inventoryToSave = Inventory()
        inventoryToSave.inventoryId = "id1"
        inventoryToSave.name = "Some name"
        inventoryToSave.descriptionText = "Desc text"
        inventoryToSave.items?.append(itemByDate)
        
        // 2. When
        inventoryDatabase.saveInventory(inventoryToSave)
        let inventoryResult: Inventory? = inventoryDatabase.getById("id1")
        
        // 3. Then
        XCTAssertNotNil(inventoryResult)
        XCTAssertNotNil(inventoryResult!.inventoryId?.elementsEqual("id1"))
        
    }
    
    func testUpdateInventorySuccessfully() {
        let item = Item()
        item.itemId = "testId2"
        item.name = "Table 2"
        
        let itemByDate = InventoryItemByDate()
        itemByDate.id = "SomeNewId"
        itemByDate.date = Date()
        itemByDate.items?.append(item)
        
        let inventoryToSave = inventoryDatabase.getById("id1")
        
        //Not good solution. Need for updateInventory method in InventoryDatabaseProtocol
        let realm = try! Realm()
        try! realm.write {
            inventoryToSave?.items?.append(itemByDate)
        }
        
        
        // 2. When
        inventoryDatabase.saveInventory(inventoryToSave)
        let inventoryResult: Inventory? = inventoryDatabase.getById("id1")
        
        // 3. Then
        XCTAssertNotNil(inventoryResult)
        XCTAssertEqual(inventoryResult!.items?.count, 2)
    }
    
    func testGetAllInventoriesSuccessfully() {
        // 1. Given
        let countOfItems = 1
        
        // 2. When
        let inventories: [Inventory]? = inventoryDatabase.getAll()

        // 3. Then
        XCTAssertNotNil(inventories)
        XCTAssertEqual(inventories!.count, countOfItems)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
