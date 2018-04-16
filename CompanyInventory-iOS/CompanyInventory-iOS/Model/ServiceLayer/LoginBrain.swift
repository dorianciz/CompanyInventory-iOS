//
//  LoginBrain.swift
//  CompanyInventory-iOS
//
//  Created by Dorian Cizmar on 4/13/18.
//  Copyright © 2018 Dorian Cizmar. All rights reserved.
//

import Foundation

class LoginBrain {
    
    var loginEngine: LoginEngineProtocol?
    var ciUserDatabase: CIUserDatabaseProtocol?
    
    init(withLoginEngine loginEngine: LoginEngineProtocol = FirebaseLoginEngine(), withCiUserDatabase database: CIUserDatabaseProtocol = CIUserRealmDatabase()) {
        self.loginEngine = loginEngine
        self.ciUserDatabase = database
    }
    
    func isEmailValid(email: String?) -> Bool? {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let isEmailValid = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        if let emailValue = email {
            return isEmailValid.evaluate(with:emailValue)
        } else {
            return nil
        }
    }
    
    func login(withUsername username: String?, withPassword password: String?, withCompletion completion: @escaping (Response) -> Void) {
        
        guard let usernameValue = username, let passwordValue = password else {
            if username == nil && password == nil {
                completion(.missingUsernameAndPassword)
            } else if username == nil {
                completion(.missingUsername)
            } else {
                completion(.missingPassword)
            }
            return
        }
        
        if usernameValue == "" && passwordValue == "" {
            completion(.missingUsernameAndPassword)
            return
        } else if usernameValue == "" {
            completion(.missingUsername)
            return
        } else if passwordValue == "" {
            completion(.missingPassword)
            return
        }
        
//        if let isEmailValid = isEmailValid(email: usernameValue) {
//            if !isEmailValid {
//                completion(.invalidUsername)
//                return
//            }
//        }
        
        loginEngine?.loginUser(withUsername: usernameValue, withPassword: passwordValue, withCompletion: { response, ciUser in
            //Save user to database
            if response == .success {
                self.ciUserDatabase?.saveCurrentUser(ciUser)
            }
            completion(response)
        })
    }
    
}
