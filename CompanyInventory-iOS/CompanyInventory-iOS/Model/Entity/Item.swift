//
//  Item.swift
//  CompanyInventory-iOS
//
//  Created by Dorian Cizmar on 2/16/18.
//  Copyright © 2018 Dorian Cizmar. All rights reserved.
//

import Foundation
import RealmSwift

enum ItemStatus: Int {
    case success = 1
    case expended
    case nonExistent
    case none
}

class Item: Object {
    
    var itemId: String?
    var name: String?
    var descriptionText: String?
    var beaconId: String?
    var status = ItemStatus.none
    var locationName: String?
    var latitude: Float?
    var longitude: Float?
    
    
}
