//
//  Response.swift
//  CompanyInventory-iOS
//
//  Created by Dorian Cizmar on 2/16/18.
//  Copyright © 2018 Dorian Cizmar. All rights reserved.
//

import Foundation

enum Response: Int {
    case success = 200
    case error = -1000
    case missingUsernameAndPassword = -2000
    case missingUsername = -2001
    case missingPassword = -2002
    case invalidUsername = -2003
}
