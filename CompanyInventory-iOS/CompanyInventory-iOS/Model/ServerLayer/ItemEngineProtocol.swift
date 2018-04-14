//
//  ItemEngineProtocol.swift
//  CompanyInventory-iOS
//
//  Created by Dorian Cizmar on 2/16/18.
//  Copyright © 2018 Dorian Cizmar. All rights reserved.
//

import Foundation

protocol ItemEngineProtocol {
    func createItem(withItem item: Item, withCompletion completion: @escaping(Response) -> Void);
    func getAllItems(withCompletion completion: @escaping([Item]?, Response) -> Void);
}
