//
//  Inventory.swift
//  CompanyInventory-iOS
//
//  Created by Dorian Cizmar on 2/15/18.
//  Copyright © 2018 Dorian Cizmar. All rights reserved.
//

import Foundation
import RealmSwift

@objc enum InventoryStatus: Int {
    case open = 1 // User is adding items
    case inProgress = 2 // User can begin scanning the same items again
    case closed = 3 // User finished scaning and create another inventory with additional items
    case none = 0
}

class Inventory: Object {
    
    @objc dynamic var inventoryId: String? = UUID().uuidString //Required
    @objc dynamic var name: String? //Required
    @objc dynamic var descriptionText: String? //Optional
    @objc private dynamic var privateStatus: Int = InventoryStatus.open.rawValue //Required
    var status: InventoryStatus {
        get { return InventoryStatus(rawValue: privateStatus)! }
        set { privateStatus = newValue.rawValue }
    }
    var items: List<InventoryItemByDate>? = List<InventoryItemByDate>() //Optional
    
    override static func primaryKey() -> String? {
        return "inventoryId"
    }
    
}

extension Inventory: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        let inventory = Inventory()
        inventory.name = name
        inventory.descriptionText = descriptionText
        inventory.privateStatus = InventoryStatus.open.rawValue
        
        let lastInventoryByDate = self.items?.last?.copy() as! InventoryItemByDate
        inventory.items?.append(lastInventoryByDate)
        
        return inventory
    }
}
