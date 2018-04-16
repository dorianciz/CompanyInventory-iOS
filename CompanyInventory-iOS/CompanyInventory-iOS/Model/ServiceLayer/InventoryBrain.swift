//
//  InventoryBrain.swift
//  CompanyInventory-iOS
//
//  Created by Dorian Cizmar on 4/16/18.
//  Copyright © 2018 Dorian Cizmar. All rights reserved.
//

import Foundation

class InventoryBrain {
    
    var inventoryDatabase: InventoryDatabaseProtocol!
    var inventoryEngine: InventoryEngineProtocol!
    
    init(withInventoryDatabase database: InventoryDatabaseProtocol = InventoryRealmDatabase(), withInventoryEngine engine: InventoryEngineProtocol = FirebaseInventoryEngine()) {
        inventoryDatabase = database
        inventoryEngine = engine
    }
    
    func fetchAllInventories(_ completion: @escaping(Response, [Inventory]?) -> Void) {
        inventoryEngine.getAllInventories { (response, inventories) in
            completion(response, inventories)
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
        
        inventoryDatabase.saveInventory(inventory)
        inventoryEngine.createInventory(withInventory: inventory) { (response) in
            completion(response)
        }
    }
    
    func getAllLocalInventories() -> [Inventory] {
        if let inventories = inventoryDatabase.getAll() {
            return inventories
        }
        return [Inventory]()
    }
    
}
