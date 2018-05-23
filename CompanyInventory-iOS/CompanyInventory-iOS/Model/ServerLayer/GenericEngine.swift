//
//  GenericEngine.swift
//  CompanyInventory-iOS
//
//  Created by Dorian Cizmar on 5/22/18.
//  Copyright © 2018 Dorian Cizmar. All rights reserved.
//

import Foundation

class GenericEngine {
    
    func performRequest(withCompletion completion: @escaping(Response) -> Void) {
        if InternetConnection.isConnectionReachable {
            completion(.success)
        } else {
            completion(.noInternetConnection)
        }
    }
    
}
