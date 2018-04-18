//
//  GeneralRealmDatabase.swift
//  CompanyInventory-iOS
//
//  Created by Dorian Cizmar on 4/19/18.
//  Copyright © 2018 Dorian Cizmar. All rights reserved.
//

import Foundation
import RealmSwift

class GeneralRealmDatabase: GeneralDatabaseProtocol {
    func clearDatabase() {
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
    }
}
