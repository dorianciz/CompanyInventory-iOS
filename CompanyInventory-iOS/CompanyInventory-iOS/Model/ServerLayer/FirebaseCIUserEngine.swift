//
//  FirebaseCIUserEngine.swift
//  CompanyInventory-iOS
//
//  Created by Dorian Cizmar on 2/16/18.
//  Copyright © 2018 Dorian Cizmar. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth
import RealmSwift

class FirebaseCIUserEngine: GenericEngine, CIUserEngineProtocol {
    
    var firebaseDatabase = Database.database().reference()
    
    func getCIUser(byUID: String?, withCompletion completion: @escaping (CIUser?, Response) -> Void) {
        // Get user from firebase database with ID from local database
        performRequest { (response) in
            if response == .noInternetConnection {
                completion(nil, .noInternetConnection)
                return
            }
            
            guard let uid = byUID else {
                completion(nil, .error)
                return
            }
            
            self.firebaseDatabase.child(Constants.kFirebaseCIUserNodeName).child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                print(snapshot)
                var ciUser: CIUser?
                if let userData = snapshot.value as? NSDictionary {
                    ciUser = CIUser()
                    ciUser!.uid = uid
                    ciUser!.username =  userData.value(forKey: Constants.kFirebaseUsernameNodeName) as? String
                    ciUser!.name = userData.value(forKey: Constants.kFirebaseNameNodeName) as? String
                    ciUser!.surname = userData.value(forKey: Constants.kFirebaseSurnameNodeName) as? String
                    ciUser!.photoPath = userData.value(forKey: Constants.kFirebasePhotoFileName) as? String
                    ciUser!.isProfileConfigured = RealmOptional<Bool>(userData.value(forKey: Constants.kFirebaseIsProfileConfigured) as? Bool)
                    ciUser!.phoneNumber = userData.value(forKey: Constants.kFirebasePhoneNumberNodeName) as? String
                }
                completion(ciUser, .success)
            })
        }
        completion(nil, .success)
    }
    
    func saveUser(user: CIUser?, withCompletion completion: @escaping (Response) -> Void) {
        guard let uid = user?.uid, let name = user?.name, let username = user?.username, let photoName = user?.photoPath, let phoneNumber = user?.phoneNumber, let isProfileConfigured = user?.isProfileConfigured.value else {
            completion(.error)
            return
        }
        
        performRequest { (response) in
            if response == .noInternetConnection {
                completion(.noInternetConnection)
                return
            }
            self.firebaseDatabase.child(Constants.kFirebaseCIUserNodeName).child(uid).setValue([Constants.kFirebaseNameNodeName: name,
                                                                                                Constants.kFirebaseUsernameNodeName: username,
                                                                                                Constants.kFirebasePhotoFileName: photoName,
                                                                                                Constants.kFirebasePhoneNumberNodeName: phoneNumber,
                                                                                                Constants.kFirebaseIsProfileConfigured: isProfileConfigured])
            completion(.success)
        }
    }
    
    func changePassword(newPassword: String, withCompletion completion: @escaping (Response) -> Void) {
        let currentUser = Auth.auth().currentUser
        currentUser?.updatePassword(to: newPassword, completion: { (error) in
            if let _ = error {
                completion(.error)
                return
            }
            
            completion(.success)
        })
    }
}
