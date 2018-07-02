//
//  PDFHandler.swift
//  CompanyInventory-iOS
//
//  Created by Dorian Cizmar on 6/27/18.
//  Copyright © 2018 Dorian Cizmar. All rights reserved.
//

import Foundation
import PDFKit
import QuartzCore

class PDFHandler {
    static let sharedInstance = PDFHandler()
    
    @discardableResult
    func generatePDFDocument(forInventory inventory: Inventory) -> Data? {
        
        return nil
    }
    
    func generatePDFDocument(forInventoryByDate inventoryByDate: InventoryItemByDate?) -> Data? {
        return nil
    }
    
}
