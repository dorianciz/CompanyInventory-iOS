//
//  InventoryRealmDatabase.swift
//  CompanyInventory-iOS
//
//  Created by Dorian Cizmar on 4/14/18.
//  Copyright © 2018 Dorian Cizmar. All rights reserved.
//

import Foundation
import RealmSwift

class InventoryRealmDatabase: InventoryDatabaseProtocol {
    
    func saveInventory(_ inventory: Inventory?) {
        guard let id = inventory?.inventoryId ,let inventoryToSave = inventory else {
            return
        }
        
        let realm = try! Realm()
        let checkIfInventoryExists = realm.objects(Inventory.self).filter("inventoryId = '\(id)'").first
        if let savedInventory = checkIfInventoryExists {
            try! realm.write {
                print(savedInventory)
                savedInventory.items = inventoryToSave.items
            }
        } else {
            try! realm.write {
                realm.add(inventoryToSave)
            }
        }
    }
    
    func getAll() -> [Inventory]? {
        let realm = try! Realm()
        return Array(realm.objects(Inventory.self))
    }
    
    func getById(_ id: String?) -> Inventory? {
        guard let idValue = id else {
            return nil
        }
        let realm = try! Realm()
        return realm.objects(Inventory.self).filter("inventoryId = '\(idValue)'").first
    }
    
    
}
