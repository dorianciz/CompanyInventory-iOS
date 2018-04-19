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
    private var userRealmDatabase: CIUserDatabaseProtocol!
    
    init(withUserDatabaseProtocol database: CIUserDatabaseProtocol = CIUserRealmDatabase()) {
        userRealmDatabase = database
    }
    
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
                                                Constants.kFirebaseItemStatusNodeName: item.status.rawValue,
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
                            Constants.kFirebaseInventoryStatusNodeName: inventoryToSave.status.rawValue,
                            Constants.kFirebaseInventoryItemsByDateNodeName: dictionaryItems] as [String : Any]
        
        let loggedInUser = userRealmDatabase.getCurrentUser()
        guard let userId = loggedInUser?.uid else {
            completion(.error)
            return
        }
        
        self.firebaseDatabase.child(Constants.kFirebaseInventoriesNodeName).child(userId).child(id).setValue(dictionary)
        
        completion(.success)
    }
    
    func getAllInventories(withCompletion completion: @escaping (Response, [Inventory]?) -> Void) {
        
        let loggedInUser = userRealmDatabase.getCurrentUser()
        guard let userId = loggedInUser?.uid else {
            completion(.error, nil)
            return
        }
        
        firebaseDatabase.child(Constants.kFirebaseInventoriesNodeName).child(userId).observeSingleEvent(of: .value, with: { (snapshot) in
            print("\(snapshot)")
            var inventories = [Inventory]()
            let inventoriesResult = snapshot.value as? NSDictionary
            
            if let inventoriesDictionary = inventoriesResult {
                for (id, inventory) in inventoriesDictionary {
                    let inventoryToSave = Inventory()
                    
                    let inventoryId = id as? String
                    var name: String?
                    var descriptionText: String?
                    var inventoryStatus: InventoryStatus = .none
                    
                    if let inventoryDictionary = inventory as? NSDictionary {
                        name = inventoryDictionary.value(forKey: Constants.kFirebaseInventoryNameNodeName) as? String
                        descriptionText = inventoryDictionary.value(forKey: Constants.kFirebaseInventoryDescriptionNodeName) as? String
                        let statusInt = inventoryDictionary.value(forKey: Constants.kFirebaseInventoryStatusNodeName) as? Int
                        let status = InventoryStatus(rawValue: statusInt ?? 0)
                        inventoryStatus = status ?? .none
                        
                        
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
                    inventoryToSave.status = inventoryStatus
                    inventories.append(inventoryToSave)
                }
                completion(.success, inventories)
            } else {
                completion(.success, nil)
            }
        })
    }
}
