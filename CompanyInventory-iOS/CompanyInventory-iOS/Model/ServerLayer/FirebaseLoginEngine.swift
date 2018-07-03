//
//  FirebaseLoginEngine.swift
//  CompanyInventory-iOS
//
//  Created by Dorian Cizmar on 2/16/18.
//  Copyright © 2018 Dorian Cizmar. All rights reserved.
//

import Foundation
import FirebaseAuth

class FirebaseLoginEngine: GenericEngine, LoginEngineProtocol {
    func loginUser(withUsername username: String, withPassword password: String, withCompletion completion: @escaping (Response, CIUser?) -> Void) {
        performRequest { (response) in
            if response == .noInternetConnection {
                completion(.noInternetConnection, nil)
                return
            }
            Auth.auth().signIn(withEmail: username, password: password) { (user, error) in
                if error == nil {
                    let ciUser = CIUser()
                    ciUser.uid = user?.user.uid
                    ciUser.username = user?.user.email
                    completion(Response.success, ciUser)
                } else {
                    completion(Response.error, nil)
                }
            }
        }
    }
    
    func signInUser(withUsername username: String, withPassword password: String, withCompletion completion: @escaping (CIUser?, Response) -> Void) {
        performRequest { (response) in
            if response == .noInternetConnection {
                completion(nil, .noInternetConnection)
                return
            }
            Auth.auth().createUser(withEmail: username, password: password, completion: { (firUser, error) in
                let newUser = CIUser()
                
                if let user = firUser {
                    newUser.username = user.user.email
                    newUser.uid = user.user.uid
                    completion(newUser, Response.success)
                } else {
                    completion(nil, Response.error)
                }  
            })
        }
    }
}
