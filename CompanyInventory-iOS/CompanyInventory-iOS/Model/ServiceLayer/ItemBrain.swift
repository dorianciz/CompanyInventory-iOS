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
    
    func deleteItem(_ item: Item!) {
        itemDatabase?.deleteItem(item)
    }
    
}
