//
//  Constants.swift
//  CompanyInventory-iOS
//
//  Created by Dorian Cizmar on 2/16/18.
//  Copyright © 2018 Dorian Cizmar. All rights reserved.
//

import Foundation

struct Constants {
    
    //Firebase constants
    //General
    static let kFirebaseCIUserNodeName = "ciUsers"
    static let kFirebaseItemNodeName = "items"
    static let kFirebaseInventoryNodeName = "inventories"
    static let kFirebaseUsernameNodeName = "username"
    static let kFirebaseNameNodeName = "name"
    static let kFirebaseSurnameNodeName = "surname"
    static let kFirebasePhotoFileName = "photoFileName"
    static let kFirebaseInventoriesNodeName = "inventories"
    //Inventory node names
    static let kFirebaseInventoryIdNodeName = "inventoryId"
    static let kFirebaseInventoryNameNodeName = "inventoryName"
    static let kFirebaseInventoryDescriptionNodeName = "inventoryDescription"
    static let kFirebaseInventoryItemsByDateNodeName = "inventoryItemsByDate"
    //ItemByDate node names
    static let kFirebaseItemByDateIdNodeName = "itemByDateId"
    static let kFirebaseItemByDateDateNodeName = "itemByDateDate"
    static let kFirebaseItemByDateItemsNodeName = "itemByDateItems"
    //Item node names
    static let kFirebaseItemIdNodeName = "itemId"
    static let kFirebaseItemNameNodeName = "itemName"
    static let kFirebaseItemDescriptionNodeName = "itemDescription"
    static let kFirebaseItemBeaconIdNodeName = "itemBeaconId"
    static let kFirebaseItemStatusNodeName = "itemStatus"
    static let kFirebaseItemLocationNameNodeName = "itemLocationName"
    static let kFirebaseItemLatitudeNodeName = "itemLatitude"
    static let kFirebaseItemLongitudeNodeName = "itemLongitude"
    
    //Storyboard ids
    static let kStoryboardName = "Main"
    static let kLoaderViewControllerStoryboardId = "LoaderViewControllerId"
    static let kInventoryReuseIdentifier = "InventoryIdentifier"
    
    //Segue ids
    static let kShowLoggedInAppSegue = "showLoggedInAppSegue"
}
