//
//  ItemBrain.swift
//  CompanyInventory-iOS
//
//  Created by Dorian Cizmar on 6/1/18.
//  Copyright © 2018 Dorian Cizmar. All rights reserved.
//

import Foundation

class ItemBrain {
    
    var itemDatabase: ItemDatabaseProtocol?
    
    init(withDatabase database: ItemDatabaseProtocol? = ItemRealmDatabase()) {
        itemDatabase = database
    }
    
    func getItem(byBeaconId beaconId: String?) -> Item? {
        guard let id = beaconId else {
            return nil
        }
        
        return itemDatabase?.getItem(byBeaconId: id)
    }
    
    func getLastItem(byBeaconId beaconId: String?) -> Item? {
        guard let id = beaconId else {
            return nil
        }
        
        return itemDatabase?.getLastItem(byBeaconId: id)
    }
    
    func deleteItem(_ item: Item!) {
        itemDatabase?.deleteItem(item)
    }
    
    func updateItem(_ item: Item?, withStatus status: ItemStatus?) {
        itemDatabase?.updateItem(item, withStatus: status)
    }
    
    func isInventoryFinished(_ allItems: [Item]?) -> Bool? {
        return allItems?.filter({$0.status != .success}).count == 0
    }
    
}
