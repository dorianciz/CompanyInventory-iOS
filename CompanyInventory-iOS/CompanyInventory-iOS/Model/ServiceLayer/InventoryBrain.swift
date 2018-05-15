//
//  InventoryBrain.swift
//  CompanyInventory-iOS
//
//  Created by Dorian Cizmar on 4/16/18.
//  Copyright © 2018 Dorian Cizmar. All rights reserved.
//

import Foundation
import RealmSwift

class InventoryBrain {
    
    var inventoryDatabase: InventoryDatabaseProtocol!
    var inventoryEngine: InventoryEngineProtocol!
    
    init(withInventoryDatabase database: InventoryDatabaseProtocol = InventoryRealmDatabase(), withInventoryEngine engine: InventoryEngineProtocol = FirebaseInventoryEngine()) {
        inventoryDatabase = database
        inventoryEngine = engine
    }
    
    func fetchAllInventories(_ completion: @escaping(Response, [Inventory]?) -> Void) {
        inventoryEngine.getAllInventories { (response, inventories) in
            // Save to database
            if let inventoriesArray = inventories {
                for inventory in inventoriesArray {
                    self.inventoryDatabase.saveInventory(inventory)
                }
                completion(response, inventoriesArray)
            } else {
                completion(response, inventories)
            }
        }
    }
    
    func createNewInventory(_ name: String?, _ description: String?, _ completion: @escaping(Response) -> Void) {
        guard let inventoryName = name else {
            completion(.missingInformations)
            return
        }
        
        let inventory = Inventory()
        inventory.name = inventoryName
        inventory.descriptionText = description
        
        inventoryEngine.createInventory(withInventory: inventory) { (response) in
            if response == .success {
                self.inventoryDatabase.saveInventory(inventory)
            }
            completion(response)
        }
    }
    
    func saveInventory(_ inventory: Inventory?, _ completion: @escaping(Response) -> Void) {
        inventoryEngine.createInventory(withInventory: inventory) { (response) in
//            if response == .success {
//                self.inventoryDatabase.saveInventory(inventory)
//            }
            completion(response)
        }
    }
    
    func getAllLocalInventories() -> [Inventory] {
        if let inventories = inventoryDatabase.getAll() {
            return inventories
        }
        return [Inventory]()
    }
    
    
    func getLocalInventoryById(_ id: String?) -> Inventory? {
        return inventoryDatabase.getById(id)
    }
    
    //If there is needed for change returned object from Realm, use this method. Changes cannot be done out of the realm write block.
    func getAndUpdateLocalInventoryById(_ id: String?, withRealmCompletion completion:@escaping(Inventory?) -> Void) {
        let realm = try! Realm()
        try! realm.write {
            completion(inventoryDatabase.getById(id))
        }
    }
    
}
