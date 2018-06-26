//
//  ItemRealmDatabase.swift
//  CompanyInventory-iOS
//
//  Created by Dorian Cizmar on 5/20/18.
//  Copyright © 2018 Dorian Cizmar. All rights reserved.
//

import Foundation
import RealmSwift

class ItemRealmDatabase: ItemDatabaseProtocol {
    func updateItem(_ item: Item?, withStatus status: ItemStatus?) {
        guard let itemToSave = item, let statusToSave = status else {
            return
        }
        
        let realm = try! Realm()
        try! realm.write {
            itemToSave.status = statusToSave
        } 
    }
    
    func updateItem(_ item: Item?) {
        guard let changedItem = item, let itemId = changedItem.itemId else {
            return
        }
        let realm = try! Realm()
        
        let predicate = NSPredicate(format: "itemId == %@", itemId)
        let itemToUpdate = realm.objects(Item.self).filter(predicate).first
        
        try! realm.write {
            itemToUpdate?.name = changedItem.name
            itemToUpdate?.descriptionText = changedItem.descriptionText
            itemToUpdate?.locationName = changedItem.locationName
            itemToUpdate?.photoLocalPath = changedItem.photoLocalPath
        }
    }
    
    func deleteItem(_ item: Item!) {
        let realm = try! Realm()
        try! realm.write {
            realm.delete(item)
        }
    }
    
    func getItem(byBeaconId beaconId: String) -> Item? {
        let realm = try! Realm()
        let predicate = NSPredicate(format: "beaconId == %@", beaconId)
        return realm.objects(Item.self).filter(predicate).first
    }
    
    func getLastItem(byBeaconId beaconId: String) -> Item? {
        let realm = try! Realm()
        let predicate = NSPredicate(format: "beaconId == %@", beaconId)
        return realm.objects(Item.self).filter(predicate).last
    }
    
}
