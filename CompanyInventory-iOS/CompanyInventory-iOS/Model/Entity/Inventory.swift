//
//  Inventory.swift
//  CompanyInventory-iOS
//
//  Created by Dorian Cizmar on 2/15/18.
//  Copyright © 2018 Dorian Cizmar. All rights reserved.
//

import Foundation
import RealmSwift

class Inventory: Object {
    
    @objc dynamic var inventoryId: String? = UUID().uuidString //Required
    @objc dynamic var name: String? //Required
    @objc dynamic var descriptionText: String? //Optional
    var items: List<InventoryItemByDate>? = List<InventoryItemByDate>() //Optional
    
    override static func primaryKey() -> String? {
        return "inventoryId"
    }
    
}
