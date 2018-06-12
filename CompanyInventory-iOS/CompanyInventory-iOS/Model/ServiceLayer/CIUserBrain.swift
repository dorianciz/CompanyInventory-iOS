//
//  CIUserBrain.swift
//  CompanyInventory-iOS
//
//  Created by Dorian Cizmar on 3/22/18.
//  Copyright © 2018 Dorian Cizmar. All rights reserved.
//

import Foundation
import UIKit

class CIUserBrain {
    
    var ciUserEngine: CIUserEngineProtocol?
    var ciUserDatabase: CIUserDatabaseProtocol?
    var documentManager: DocumentManager?
    
    
    init(withCIUserEngine userEngine: CIUserEngineProtocol = FirebaseCIUserEngine(), withCIUserDatabase database: CIUserDatabaseProtocol = CIUserRealmDatabase()) {
        ciUserEngine = userEngine
        ciUserDatabase = database
        documentManager = DocumentManager()
    }
    
    func fetchCurrentUserProfile(withCompletion completion: @escaping(CIUser?, Response) -> Void) {
        ciUserEngine?.getCIUser(byUID: getCurrentUserUid(), withCompletion: { (ciUser, response) in
            if let ciUser = ciUser {
                self.ciUserDatabase?.saveCurrentUser(ciUser)
            }
            completion(ciUser, response)
        })
    }
    
    func saveUserProfileData(withUid uid: String?, withUsername username: String?, withNameAndSurname nameAndSurname: String?, withProfileImage profileImage: UIImage?, withPhoneNumber phoneNumber: String?, withCompletion completion: @escaping(Response) -> Void) {
        guard let _ = profileImage, let _ = username, let nameAndSurnameValue = nameAndSurname, let phoneNumberValue = phoneNumber, let uid = uid, nameAndSurnameValue != "", phoneNumberValue != "" else {
            completion(.missingInformations)
            return
        }
        
        let ciUser = CIUser()
        ciUser.uid = uid
        ciUser.username = username
        ciUser.name = nameAndSurname
        ciUser.photoPath = uid
        ciUser.phoneNumber = phoneNumber
        ciUser.isProfileConfigured.value = true
        
        documentManager?.saveImageToDocumentDirectory(ciUser.photoPath, profileImage)
        
        ciUserEngine?.saveUser(user: ciUser, withCompletion: { (response) in
            if response == .success {
                self.ciUserDatabase?.saveCurrentUser(ciUser)
            }
            completion(response)
        })
        
    }
    
    func changePassword(newPassword: String?, repeatedPassword: String?, withCompletion completion: @escaping (Response) -> Void) {
        guard let new = newPassword, let repeated = repeatedPassword else {
            completion(.missingInformations)
            return
        }
        
        if new != repeated {
            completion(.passwordsMissmatch)
            return
        }
        
        ciUserEngine?.changePassword(newPassword: new, withCompletion: { (response) in
            completion(response)
        })
        
    }
    
    func getCurrentUser() -> CIUser? {
        return self.ciUserDatabase?.getCurrentUser()
    }
    
    func getCurrentUserUid() -> String? {
        return ciUserDatabase?.getCurrentUser()?.uid
    }
    
}
