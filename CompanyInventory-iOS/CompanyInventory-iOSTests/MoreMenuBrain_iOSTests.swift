//
//  MoreMenuBrain_iOSTests.swift
//  CompanyInventory-iOSTests
//
//  Created by Dorian Cizmar on 6/3/18.
//  Copyright © 2018 Dorian Cizmar. All rights reserved.
//

import XCTest
@testable import CompanyInventory_iOS

class MoreMenuBrain_iOSTests: XCTestCase {
    
    var brain: MoreMenuBrain!
    var data: MoreTabItemsProtocol!
    
    override func setUp() {
        super.setUp()
        brain = MoreMenuBrain(withData: MoreTabTestItems())
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        brain = nil
        data = nil
        super.tearDown()
    }
    
    func testRowsInSectionForData() {
        // 1. Given
        var result: Int
        let section = 0
        let expectedResult = 3
        
        // 2. When
        result = brain.getNumberOfRows(inSection: section)
        
        // 3. Then
        XCTAssertEqual(result, expectedResult)
    }
    
    func testNumberOfSectionForData() {
        // 1. Given
        var result: Int
        let expectedResult = 3
        
        // 2. When
        result = brain.getNumberOfSections()
        
        // 3. Then
        XCTAssertEqual(result, expectedResult)
    }
    
    func testGetMoreItemDataWithSpecificPosition() {
        // 1. Given
        var result: MoreItemData?
        let position = 0
        let section = 2
        let expectedResult = "Log Out"
        
        // 2. When
        result = brain.getMoreItemData(onPosition: position, inSection: section)
        
        // 3. Then
        XCTAssertNotNil(result)
        XCTAssertTrue(result!.title == expectedResult)
    }
    
    func testGettingKeyForValue() {
        // 1. Given
        let expectedResult: MoreItem = .Logout
        let valueItem = brain.getMoreItemData(onPosition: 0, inSection: 2)
        
        // 2. When
        let result = brain.getMoreItemType(valueItem)
        
        // 3. Then
        XCTAssertNotNil(result)
        XCTAssertEqual(result, expectedResult)
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
