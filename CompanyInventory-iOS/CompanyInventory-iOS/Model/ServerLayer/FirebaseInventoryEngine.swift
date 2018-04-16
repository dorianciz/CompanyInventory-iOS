//
//  FirebaseInventoryEngine.swift
//  CompanyInventory-iOS
//
//  Created by Dorian Cizmar on 4/15/18.
//  Copyright © 2018 Dorian Cizmar. All rights reserved.
//

import Foundation
import FirebaseDatabase
import RealmSwift

class FirebaseInventoryEngine: InventoryEngineProtocol {
    
    var firebaseDatabase = Database.database().reference()
    
    func createInventory(withInventory inventory: Inventory?, withCompletion completion: @escaping (Response) -> Void) {
        guard let id = inventory?.inventoryId, let inventoryToSave = inventory else {
            completion(.error)
            return
        }
        
        var dictionaryItems: [String: Any] = [String: Any]()
        
        if let itemsByDates = inventoryToSave.items {
            for itemByDate in itemsByDates {
                if let items = itemByDate.items {
                    var itemsDictionary = [String: Any]()
                    for item in items {
                        guard let id = item.itemId, let name = item.name, let beaconId = item.beaconId, let locationName = item.locationName else {
                            completion(.error)
                            return
                        }
                        
                        itemsDictionary[id] = [ Constants.kFirebaseItemNameNodeName: name,
                                                Constants.kFirebaseItemDescriptionNodeName: item.descriptionText ?? "",
                                                Constants.kFirebaseItemBeaconIdNodeName: beaconId,
                                                Constants.kFirebaseItemStatusNodeName: item.status,
                                                Constants.kFirebaseItemLocationNameNodeName: locationName,
                                                Constants.kFirebaseItemLongitudeNodeName: item.longitude,
                                                Constants.kFirebaseItemLatitudeNodeName: item.latitude]
                    }
                    
                    guard let id = itemByDate.id, let date = itemByDate.date else {
                        completion(.error)
                        return
                    }
                    
                    let formatter = DateFormatter()
//                    formatter.dateFormat = "yyyy/MM/dd, H:mm:ss"
                    formatter.dateFormat = "yyyy/MM/dd"
                    let defaultTimeZoneStr = formatter.string(from: date)
                    
                    dictionaryItems[id] = [ Constants.kFirebaseItemByDateDateNodeName: defaultTimeZoneStr,
                                            Constants.kFirebaseItemByDateItemsNodeName: itemsDictionary]
                }
            }
        }
        
        guard let name = inventoryToSave.name else {
            completion(.error)
            return
        }
        
        let dictionary = [  Constants.kFirebaseInventoryNameNodeName: name,
                            Constants.kFirebaseInventoryDescriptionNodeName: inventoryToSave.descriptionText ?? "",
                            Constants.kFirebaseInventoryItemsByDateNodeName: dictionaryItems] as [String : Any]
        
        self.firebaseDatabase.child(Constants.kFirebaseInventoriesNodeName).child(id).setValue(dictionary)
        
        completion(.success)
    }
    
    func getAllInventories(withCompletion completion: @escaping (Response, [Inventory]?) -> Void) {
        firebaseDatabase.child(Constants.kFirebaseInventoriesNodeName).observeSingleEvent(of: .value, with: { (snapshot) in
            print("\(snapshot)")
            var inventories = [Inventory]()
            let inventoriesResult = snapshot.value as? NSDictionary
            
            if let inventoriesDictionary = inventoriesResult {
                for (id, inventory) in inventoriesDictionary {
                    let inventoryToSave = Inventory()
                    
                    let inventoryId = id as? String
                    var name: String?
                    var descriptionText: String?
                    
                    if let inventoryDictionary = inventory as? NSDictionary {
                        name = inventoriesDictionary.value(forKey: Constants.kFirebaseInventoryNameNodeName) as? String
                        descriptionText = inventoriesDictionary.value(forKey: Constants.kFirebaseInventoryDescriptionNodeName) as? String
                        
                        let itemsByDate = inventoryDictionary.value(forKey: Constants.kFirebaseInventoryItemsByDateNodeName) as? NSDictionary
                        
                        if let itemsByDateDictionary = itemsByDate {
                            for (id, itemByDate) in itemsByDateDictionary {
                                if let itemByDateDictionary = itemByDate as? NSDictionary {
                                    let itemByDateToSave = InventoryItemByDate()
                                    itemByDateToSave.id = id as? String
                                    
                                    let dateString = itemByDateDictionary.value(forKey: Constants.kFirebaseItemByDateDateNodeName) as? String
                                    let dateFormatter = DateFormatter()
                                    dateFormatter.dateFormat = "yyyy/MM/dd"
                                    let date = dateFormatter.date(from: dateString!)
                                    
                                    itemByDateToSave.date = date
                                    
                                    if let itemsDictionary = itemByDateDictionary.value(forKey: Constants.kFirebaseItemByDateItemsNodeName) as? NSDictionary {
                                        for (id, item) in itemsDictionary {
                                            if let itemDictionary = item as? NSDictionary {
                                                let itemToSave = Item()
                                                itemToSave.itemId = id as? String
                                                itemToSave.descriptionText = itemDictionary.value(forKey: Constants.kFirebaseItemDescriptionNodeName) as? String
                                                itemToSave.beaconId = itemDictionary.value(forKey: Constants.kFirebaseItemBeaconIdNodeName) as? String
                                                
                                                let statusInt = itemDictionary.value(forKey: Constants.kFirebaseItemStatusNodeName) as? Int
                                                let status = ItemStatus(rawValue: statusInt ?? 4)
                                                
                                                itemToSave.status = status ?? .none
                                                itemToSave.locationName = itemDictionary.value(forKey: Constants.kFirebaseItemLocationNameNodeName) as? String
                                                itemToSave.longitude = RealmOptional(itemDictionary.value(forKey: Constants.kFirebaseItemLongitudeNodeName) as? Float)
                                                itemToSave.latitude = RealmOptional(itemDictionary.value(forKey: Constants.kFirebaseItemLatitudeNodeName) as? Float)
                                                itemByDateToSave.items?.append(itemToSave)
                                            }
                                        }
                                    }
                                    inventoryToSave.items?.append(itemByDateToSave)
                                }
                            }
                        }
                    }
                    inventoryToSave.inventoryId = inventoryId
                    inventoryToSave.name = name
                    inventoryToSave.descriptionText = descriptionText
                    inventories.append(inventoryToSave)
                }
                completion(.success, inventories)
            } else {
                completion(.success, nil)
            }
        })
    }
}
