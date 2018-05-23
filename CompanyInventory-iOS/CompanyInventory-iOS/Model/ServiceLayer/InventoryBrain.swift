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
    
    var itemDatabase: ItemDatabaseProtocol!
    var inventoryDatabase: InventoryDatabaseProtocol!
    var inventoryEngine: InventoryEngineProtocol!
    var documentManager = DocumentManager()
    var bluetoothManager = BluetoothConnection()
    
    
    init(withInventoryDatabase database: InventoryDatabaseProtocol = InventoryRealmDatabase(), withInventoryEngine engine: InventoryEngineProtocol = FirebaseInventoryEngine(), withItemDatabase itemDatabase: ItemDatabaseProtocol = ItemRealmDatabase()) {
        inventoryDatabase = database
        inventoryEngine = engine
        self.itemDatabase = itemDatabase
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
            completion(response)
        }
    }
    
    func saveItem(_ item: Item!, toInventoryByDate inventoryByDateId: String?, toInventoryWithId inventoryId: String?, _ completion: @escaping(Response) -> Void) {
        if !isItemDataValid(item) {
            completion(.missingInformations)
            return
        }
        
        documentManager.saveImageToDocumentDirectory(item.photoLocalPath!, item.image!)
        
        if let inventoryId = inventoryId {
            getAndUpdateLocalInventoryById(inventoryId, withRealmCompletion: { inventory in
                var foundInventoryByDate = false
                if let items = inventory?.items {
                    items.forEach { (inventoryByDate) in
                        if let id = inventoryByDate.id, let inventoryItemByDateId = inventoryByDateId {
                            if id == inventoryItemByDateId {
                                foundInventoryByDate = true
                                inventoryByDate.items?.append(item)
                            }
                        }
                    }
                    
                    if !foundInventoryByDate {
                        // Create new InventoryByDate
                        let inventoryByDate = InventoryItemByDate()
                        inventoryByDate.date = Date()
                        inventoryByDate.items!.append(item)
                        inventory!.items!.append(inventoryByDate)
                    }
                }
                
                self.saveInventory(inventory) { (response) in
                    completion(response)
                }
            })
            
            
        }
    }
    
    func isItemDataValid(_ item: Item) -> Bool {
        if let id = item.itemId, let name = item.name, let beaconId = item.beaconId, let locationName = item.locationName, let _ = item.latitude.value, let _ = item.longitude.value, let _ = item.photoLocalPath {
            return id != "" && name != "" && beaconId != "" && locationName != ""
        }
        return false
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
    
    func getUsedBeaconIdsFromLocalItems(forInventoryId id: String, forInventoryByDateId inventoryByDateId: String) -> [String]? {
        var items: [String]?
        
        let localInventory = getLocalInventoryById(id)
        localInventory?.items?.forEach({ (inventoryByDate) in
            if inventoryByDate.id! == inventoryByDateId {
                items = [String]()
                Array(inventoryByDate.items!).forEach({ (item) in
                    if let beaconId = item.beaconId {
                        items?.append(beaconId)
                    }
                })
                
            }
        })
        
        return items
    }
    
    func updateItem(_ item: Item?, withStatus status: ItemStatus?) {
        itemDatabase.updateItem(item, withStatus: status)
    }
    
    func checkIsInventoryFinished(_ items: [Item]?) -> Bool? {
        guard let allItems = items else {
            return nil
        }
        
        for item in allItems {
            if (item.status == .none) {
                return false
            }
        }
        
        return true
    }
    
    func checkBluetoothConnection(_ completion: @escaping(Response) -> Void) {
        if let state = bluetoothManager.currentBluetoothState {
            switch state {
            case .poweredOn:
                completion(.bluetoothOn)
            default:
                completion(.bluetoothError)
            }
        }
    }
    
}
