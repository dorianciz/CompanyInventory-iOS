//
//  LoginEngineProtocol.swift
//  CompanyInventory-iOS
//
//  Created by Dorian Cizmar on 2/16/18.
//  Copyright © 2018 Dorian Cizmar. All rights reserved.
//

import Foundation

protocol LoginEngineProtocol {
    func loginUser(withUsername username: String, withPassword password: String, withCompletion completion: @escaping (Response, CIUser?) -> Void)
    func signInUser(withUsername username: String, withPassword password: String, withCompletion completion: @escaping (CIUser?, Response) -> Void)
}
