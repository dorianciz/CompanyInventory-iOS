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
}
