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
            // Sort and save to database
            if var inventoriesArray = inventories {
                inventoriesArray.sort(by: { $0.creationDate! < $1.creationDate! })
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
        guard let inventoryName = name, let _ = description else {
            completion(.missingInformations)
            return
        }
        var inventory: Inventory!
        inventory = Inventory()
        inventory.creationDate = Date()
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
    
    func updateItem(_ itemToUpdate: Item?, forInventoryId inventoryId: String?, forItemByDateId itemByDateId: String?, completion: @escaping(Response) -> Void) {
        guard let item = itemToUpdate else {
            return
        }
        
        if !isItemDataValid(item) {
            completion(.missingInformations)
            return
        }
        
        documentManager.saveImageToDocumentDirectory(item.photoLocalPath!, item.image!)
        
        itemDatabase.updateItem(item)
        
        getAndUpdateLocalInventoryById(inventoryId) { (inventory) in
            self.saveInventory(inventory, { (response) in
                completion(response)
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
                    // If beacon id exists, it means that item was scanned. If not, item should be scanned yet
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
    
    func addNewInventoryByDate(toInventory inventory: Inventory?, _ completion: @escaping(Inventory?, Response) -> Void) {
        if let items = inventory?.items?.last?.items {
            let inventoryByDate = InventoryItemByDate()
            inventoryByDate.date = Date()
            
            for item in items {
                if item.status == .success {
                    let copiedItem = item.copy() as! Item
                    copiedItem.status = .none
                    inventoryByDate.items?.append(copiedItem)
                }
            }
            
            let realm = try! Realm()
            try! realm.write {
                inventory?.items?.append(inventoryByDate)
            }
            inventoryEngine.createInventory(withInventory: inventory) { (response) in
                completion(inventory, response)
            }
            
            return
        }
        completion(nil, .error)
    }
    
    func getImagesForInventory(_ inventory: Inventory?) -> [String:UIImage]? {
        var images = [String:UIImage]()
        
        if let inventoriesByDate = inventory?.items {
            for inventoryByDate in inventoriesByDate {
                if let items = inventoryByDate.items {
                    for item in items {
                        if let imagePath = item.photoLocalPath {
                            if images[imagePath] == nil, let image = documentManager.getImageFromDocument(withName: imagePath) {
                                images[imagePath] = image
                            }
                        }
                    }
                }
            }
        }
        
        return images
    }
    
    func updateInventoryStatus(_ inventory: Inventory!, _ status: InventoryStatus!,_ completion: @escaping(Response) -> Void) {
        let realm = try! Realm()
        try! realm.write {
            inventory.status = status
        }
        inventoryEngine.createInventory(withInventory: inventory) { (response) in
            completion(response)
        }
    }
    
    func clearAllInventories(withCompletion completion: @escaping(Response) -> Void) {
        inventoryEngine.clearAllInventories { (response) in
            if response == .success {
                self.inventoryDatabase.clearAll()
            }
            completion(response)
        }
    }
    
    func getItem(fromInventory: Inventory?, forIndexPath indexPath: IndexPath!, andPosition position: ItemPosition!) -> Item? {
        guard let items = fromInventory?.items?[indexPath.section].items else {
            return nil
        }
        
        var item: Item?
        
        switch position {
        case .left:
            item = items.indices.contains(((indexPath.row) * 3)) ? items[((indexPath.row) * 3)] : nil
        case .center:
            item = items.indices.contains(((indexPath.row) * 3) + 1) ? items[((indexPath.row) * 3) + 1] : nil
        case .right:
            item = items.indices.contains(((indexPath.row) * 3) + 2) ? items[((indexPath.row) * 3) + 2] : nil
        default:
            break
        }
        
        return item
    }
    
    func getItemByDateId(fromInventory: Inventory?, forSection section: Int!) -> String? {
        guard let itemByDate = fromInventory?.items?[section] else {
            return nil
        }
        return itemByDate.id
    }
    
    func getItemByDate(fromInventory: Inventory?, forSection section: Int) -> InventoryItemByDate? {
        return fromInventory?.items?[section]
    }
    
    func getReportsPath(forInventory inventory: Inventory?) -> String? {
        if let id = inventory?.inventoryId {
            return "\(Constants.kReportsDirectory)/\(id).pdf"
        }
        return nil
    }
    
}
