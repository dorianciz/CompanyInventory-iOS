//
//  PersistanceService.swift
//  CompanyInventory-iOS
//
//  Created by Dorian Cizmar on 6/5/18.
//  Copyright © 2018 Dorian Cizmar. All rights reserved.
//

import Foundation

class PersistanceService {
    static let sharedInstance = PersistanceService()
    
    private let kStaySignedIn = "StaySignedIn"
    
    func setStaySignedIn(_ value: Bool!) {
        UserDefaults.standard.set(value, forKey: kStaySignedIn)
    }
    
    func shouldStaySignedIn() -> Bool? {
        return UserDefaults.standard.value(forKey: kStaySignedIn) as? Bool
    }
}
