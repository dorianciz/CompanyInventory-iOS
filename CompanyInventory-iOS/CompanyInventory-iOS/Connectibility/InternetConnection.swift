//
//  InternetConnection.swift
//  CompanyInventory-iOS
//
//  Created by Dorian Cizmar on 5/22/18.
//  Copyright © 2018 Dorian Cizmar. All rights reserved.
//

import Foundation

class InternetConnection {
    static var isConnectionReachable: Bool! {
        get {
            let reachability = Reachability.forInternetConnection()
            let networkStatus = reachability?.currentReachabilityStatus()
            return networkStatus! != NotReachable
        }
    }
}
