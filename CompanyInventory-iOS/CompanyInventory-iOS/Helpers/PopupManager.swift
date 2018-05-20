//
//  PopupManager.swift
//  CompanyInventory-iOS
//
//  Created by Dorian Cizmar on 4/18/18.
//  Copyright © 2018 Dorian Cizmar. All rights reserved.
//

import Foundation
import UIKit

class PopupManager {
    static let sharedInstance = PopupManager()
    
    func showGenericPopup(withTitle title: String, withMessage message: String, withTextFieldsPlaceholders placeholders: [String]?, withOkCompletion completion:@escaping([String]) -> Void) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let addAction = UIAlertAction(title: NSLocalizedString(Constants.LocalizationKeys.kInventoryAddButton, comment: ""), style: .default) { (action) in
            var result = [String]()
            if let textFieldPlaceholders = placeholders {
                for index in 0..<textFieldPlaceholders.count {
                    result.append(alertController.textFields?[index].text ?? "")
                }
            }
            completion(result)
        }
        
        let cancelAction = UIAlertAction(title: NSLocalizedString(Constants.LocalizationKeys.kGeneralCancel, comment: ""), style: .cancel, handler: nil)
        
        placeholders?.forEach {
            let title = $0
            alertController.addTextField(configurationHandler: { textField in
                textField.placeholder = title
            })
        }
        
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        
        return alertController
    }
    
    func showInfoPopup(withTitle title: String, withMessage message: String) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    
        let okAction = UIAlertAction(title: NSLocalizedString(Constants.LocalizationKeys.kGeneralOk, comment: ""), style: .default, handler: nil)
        alertController.addAction(okAction)
        
        return alertController
    }
    
}
