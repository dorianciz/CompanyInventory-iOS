//
//  CIUserBrain.swift
//  CompanyInventory-iOS
//
//  Created by Dorian Cizmar on 3/22/18.
//  Copyright © 2018 Dorian Cizmar. All rights reserved.
//

import Foundation

class CIUserBrain {
    
    var ciUserEngine: CIUserEngineProtocol?
    
    init(withCIUserEngine userEngine: CIUserEngineProtocol = FirebaseCIUserEngine()) {
        ciUserEngine = userEngine
    }
    
}
