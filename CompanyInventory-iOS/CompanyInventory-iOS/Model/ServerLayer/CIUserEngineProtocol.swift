//
//  CIUserEngineProtocol.swift
//  CompanyInventory-iOS
//
//  Created by Dorian Cizmar on 2/16/18.
//  Copyright © 2018 Dorian Cizmar. All rights reserved.
//

import Foundation

protocol CIUserEngineProtocol {
    func getCIUser(byUID: String?, withCompletion completion: @escaping (CIUser?, Response) -> Void)
    func saveUser(user: CIUser?, withCompletion completion:@escaping (Response) -> Void)
    func changePassword(newPassword: String, withCompletion completion: @escaping(Response) -> Void)
}
