//
//  Item.swift
//  CompanyInventory-iOS
//
//  Created by Dorian Cizmar on 2/16/18.
//  Copyright © 2018 Dorian Cizmar. All rights reserved.
//

import Foundation
import RealmSwift

@objc enum ItemStatus: Int {
    case success = 1
    case expired = 2
    case nonExistent = 3
    case none = 4
}

class Item: Object {
    
    @objc dynamic var itemId: String? = UUID().uuidString //Required
    @objc dynamic var name: String? //Required
    @objc dynamic var descriptionText: String? //Optional
    @objc dynamic var beaconId: String? //Required
    @objc dynamic var status = ItemStatus.none //Required
    @objc dynamic var locationName: String? //Required
    @objc dynamic var photoLocalPath: String? //Optional
    @objc dynamic var photoFirebasePath: String? //Optional
    var latitude = RealmOptional<Float>() //Required
    var longitude = RealmOptional<Float>() //Required
    
    var image: UIImage?
    
    
    override static func primaryKey() -> String? {
        return "itemId"
    }
    
}
