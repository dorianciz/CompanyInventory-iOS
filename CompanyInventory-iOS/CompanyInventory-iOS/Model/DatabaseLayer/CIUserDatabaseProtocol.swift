//
//  CIUserDatabaseProtocol.swift
//  CompanyInventory-iOS
//
//  Created by Dorian Cizmar on 4/14/18.
//  Copyright © 2018 Dorian Cizmar. All rights reserved.
//

import Foundation

protocol CIUserDatabaseProtocol {
    func getUserByUid(_ uid: String?) -> CIUser?
    func saveCurrentUser(_ user: CIUser?) -> Bool?
    func getCurrentUser() -> CIUser?
    func deleteCurrentUser()
}
