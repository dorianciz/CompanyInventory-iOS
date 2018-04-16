//
//  FirebaseLoginEngine.swift
//  CompanyInventory-iOS
//
//  Created by Dorian Cizmar on 2/16/18.
//  Copyright © 2018 Dorian Cizmar. All rights reserved.
//

import Foundation
import FirebaseAuth

class FirebaseLoginEngine: LoginEngineProtocol {
    func loginUser(withUsername username: String, withPassword password: String, withCompletion completion: @escaping (Response, CIUser?) -> Void) {
        Auth.auth().signIn(withEmail: username, password: password) { (user, error) in
            if error == nil {
                let ciUser = CIUser()
                completion(Response.success, ciUser)
            } else {
                completion(Response.error, nil)
            }
        }
    }
    
    func signInUser(withUsername username: String, withPassword password: String, withCompletion completion: @escaping (CIUser?, Response) -> Void) {
        Auth.auth().createUser(withEmail: username, password: password, completion: { (firUser, error) in
            let newUser = CIUser()
            
            if let user = firUser {
                newUser.username = user.email
                newUser.uid = user.uid
                completion(newUser, Response.success)
            } else {
                completion(nil, Response.error)
            }
            
        })
    }
}
