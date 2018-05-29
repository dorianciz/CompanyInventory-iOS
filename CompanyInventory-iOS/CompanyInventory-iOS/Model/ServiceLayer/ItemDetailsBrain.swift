//
//  ItemDetailsBrain.swift
//  CompanyInventory-iOS
//
//  Created by Dorian Cizmar on 5/30/18.
//  Copyright © 2018 Dorian Cizmar. All rights reserved.
//

import Foundation
import UIKit

class ItemDetailsBrain {
    
    let documentManager = DocumentManager()
    
    func getImage(forPath path: String?) -> UIImage? {
        if let path = path {
            return documentManager.getImageFromDocument(withName: path)
        }
        return nil
    }
    
}
