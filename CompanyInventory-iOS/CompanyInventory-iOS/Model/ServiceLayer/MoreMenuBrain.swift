//
//  MoreMenuBrain.swift
//  CompanyInventory-iOS
//
//  Created by Dorian Cizmar on 6/3/18.
//  Copyright © 2018 Dorian Cizmar. All rights reserved.
//

import UIKit

class MoreMenuBrain: NSObject {
    
    private var data: MoreTabItemsProtocol!
    
    init(withData data: MoreTabItemsProtocol? = MoreTabItems()) {
        self.data = data
    }
    
    func getNumberOfRows(inSection section: Int) -> Int {
        var counter = 0
        for row in data.rowsItems {
            if row.value.section == section {
                counter = counter + 1
            }
        }
        
        return counter
    }
    
    func getNumberOfSections() -> Int {
        var uniqueArrayOfSections = [Int]()
        for row in data.rowsItems {
            if !uniqueArrayOfSections.contains(row.value.section) {
                uniqueArrayOfSections.append(row.value.section)
            }
        }
        
        return uniqueArrayOfSections.count
    }
    
    func getMoreItemData(onPosition position: Int, inSection section: Int) -> MoreItemData? {
        for item in data.rowsItems {
            if item.value.section == section && item.value.positionInSection == position {
                return item.value
            }
        }
        return nil
    }
    
    func getMoreItemType(_ item: MoreItemData?) -> MoreItem? {
        guard let itemData = item else {
            return nil
        }
        
        let result = data.rowsItems.filter({return $1.title == itemData.title})
        
        return result.first?.key
    }
}
