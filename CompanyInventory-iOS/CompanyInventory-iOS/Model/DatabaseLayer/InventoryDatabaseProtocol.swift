//
//  InventoryDatabaseProtocol.swift
//  CompanyInventory-iOS
//
//  Created by Dorian Cizmar on 4/14/18.
//  Copyright © 2018 Dorian Cizmar. All rights reserved.
//

import Foundation

protocol InventoryDatabaseProtocol {
    func saveInventory(_ inventory: Inventory?)
    func getAll() -> [Inventory]?
    func getById(_ id: String?) -> Inventory?
}
