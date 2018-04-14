//
//  FirebaseCIUserEngine.swift
//  CompanyInventory-iOS
//
//  Created by Dorian Cizmar on 2/16/18.
//  Copyright © 2018 Dorian Cizmar. All rights reserved.
//

import Foundation
import FirebaseDatabase

class FirebaseCIUserEngine: CIUserEngineProtocol {
    
    var firebaseDatabase = Database.database().reference()
    
    func getCIUser(byUID: String, withCompletion completion: @escaping (CIUser, Response) -> Void) {
        
    }
    
    func saveUser(user: CIUser, withCompletion completion: @escaping (Response) -> Void) {
        guard let uid = user.uid, let username = user.username, let name = user.name, let surname = user.surname, let photoName = user.photoName else {
            completion(.error)
            return
        }
        
        self.firebaseDatabase.child(Constants.kFirebaseCIUserNodeName).child(uid).setValue([Constants.kFirebaseUsernameNodeName: username])
        self.firebaseDatabase.child(Constants.kFirebaseCIUserNodeName).child(uid).setValue([Constants.kFirebaseNameNodeName: name])
        self.firebaseDatabase.child(Constants.kFirebaseCIUserNodeName).child(uid).setValue([Constants.kFirebaseSurnameNodeName: surname])
        self.firebaseDatabase.child(Constants.kFirebaseCIUserNodeName).child(uid).setValue([Constants.kFirebasePhotoFileName: photoName])
    
        completion(.success)
    }
}
