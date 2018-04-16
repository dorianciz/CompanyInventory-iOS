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
    var ciUserDatabase: CIUserDatabaseProtocol?
    
    init(withCIUserEngine userEngine: CIUserEngineProtocol = FirebaseCIUserEngine(), withCIUserDatabase database: CIUserDatabaseProtocol = CIUserRealmDatabase()) {
        ciUserEngine = userEngine
        ciUserDatabase = database
    }
    
    func getCurrentUserUid() -> String? {
        return ciUserDatabase?.getCurrentUser()?.uid
    }
    
}
