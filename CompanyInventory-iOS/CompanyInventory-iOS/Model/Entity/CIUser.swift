//
//  CIUser.swift
//  CompanyInventory-iOS
//
//  Created by Dorian Cizmar on 2/16/18.
//  Copyright © 2018 Dorian Cizmar. All rights reserved.
//

import Foundation
import RealmSwift

class CIUser: Object {
    @objc dynamic var uid: String?
    @objc dynamic var username: String?
    @objc dynamic var password: String?
    @objc dynamic var name: String?
    @objc dynamic var surname: String?
    @objc dynamic var photoName: String?
    var photoData: Data?
    var inventories: [Inventory]?
    
    override static func primaryKey() -> String? {
        return "uid"
    }
}
