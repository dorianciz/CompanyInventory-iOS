//
//  ItemDatabaseProtocol.swift
//  CompanyInventory-iOS
//
//  Created by Dorian Cizmar on 5/20/18.
//  Copyright © 2018 Dorian Cizmar. All rights reserved.
//

import Foundation

protocol ItemDatabaseProtocol {
    func updateItem(_ item: Item?, withStatus status: ItemStatus?)
    func deleteItem(_ item: Item!)
    func getItem(byBeaconId beaconId: String) -> Item?
}
