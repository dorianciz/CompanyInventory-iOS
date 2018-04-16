//
//  CIUserRealmDatabase.swift
//  CompanyInventory-iOS
//
//  Created by Dorian Cizmar on 4/14/18.
//  Copyright © 2018 Dorian Cizmar. All rights reserved.
//

import Foundation
import RealmSwift

class CIUserRealmDatabase: CIUserDatabaseProtocol {
    
    func getUserByUid(_ uid: String?) -> CIUser? {
        guard let uidValue = uid else {
            return nil
        }
        let realm = try! Realm()
        return realm.objects(CIUser.self).filter("uid = '\(uidValue)'").first
    }
    
    func saveCurrentUser(_ user: CIUser?) -> Bool? {
        guard let uid = user?.uid, let userToSave = user else {
            return false
        }
        
        let realm = try! Realm()
        let checkIfUserExists = realm.objects(CIUser.self).filter("uid = '\(uid)'").first
        if var savedUser = checkIfUserExists {
            try! realm.write {
                print(savedUser)
                savedUser.name = userToSave.name
                savedUser.surname = userToSave.surname
                savedUser.photoName = userToSave.photoName
                savedUser.photoData = userToSave.photoData
            }
        } else {
            try! realm.write {
                realm.add(userToSave)
            }
        }
        return true
    }
    
    func deleteCurrentUser() {
        let realm = try! Realm()
        let allUsers = realm.objects(CIUser.self)
        try! realm.write {
            realm.delete(allUsers)
        }
    }
    
    func getCurrentUser() -> CIUser? {
        let realm = try! Realm()
        return realm.objects(CIUser.self).first
    }
    
}
