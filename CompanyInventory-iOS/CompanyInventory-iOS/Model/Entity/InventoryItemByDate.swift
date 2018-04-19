//
//  InventoryItemByDate.swift
//  CompanyInventory-iOS
//
//  Created by Dorian Cizmar on 4/14/18.
//  Copyright © 2018 Dorian Cizmar. All rights reserved.
//

import Foundation
import RealmSwift

class InventoryItemByDate: Object {
    @objc dynamic var id: String? = UUID().uuidString //Required
    @objc dynamic var date: Date? //Required
    var items: List<Item>? = List<Item>() //Required
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}
