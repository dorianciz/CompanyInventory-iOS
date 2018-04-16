//
//  InventoryEngineProtocol.swift
//  CompanyInventory-iOS
//
//  Created by Dorian Cizmar on 4/15/18.
//  Copyright © 2018 Dorian Cizmar. All rights reserved.
//

import Foundation

protocol InventoryEngineProtocol {
    func createInventory(withInventory inventory: Inventory?, withCompletion completion:@escaping(Response) -> Void)
    func getAllInventories(withCompletion completion: @escaping(Response, [Inventory]?) -> Void)
}
