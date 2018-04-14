//
//  FirebaseItemEngine.swift
//  CompanyInventory-iOS
//
//  Created by Dorian Cizmar on 2/16/18.
//  Copyright © 2018 Dorian Cizmar. All rights reserved.
//

import Foundation
import FirebaseDatabase

class FirebaseItemEngine: ItemEngineProtocol {
    
    var firebaseDatabase = Database.database().reference()
    
    func createItem(withItem item: Item, withCompletion completion: @escaping (Response) -> Void) {
        completion(Response.success)
    }
    
    func getAllItems(withCompletion completion: @escaping ([Item]?, Response) -> Void) {
        firebaseDatabase.child("test").observeSingleEvent(of: .value, with: { (snapshot) in
            print("\(snapshot)")
        })
    }
}
