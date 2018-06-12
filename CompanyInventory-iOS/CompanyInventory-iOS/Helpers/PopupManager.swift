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
    
    func showGenericPopup(withTitle title: String, withMessage message: String, withTextFieldsPlaceholders placeholders: [String]?, isPasswordType: Bool! = false, withOkCompletion completion:@escaping([String]) -> Void) -> UIAlertController {
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
                textField.isSecureTextEntry = isPasswordType
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
    
    func showPopup(withTitle title: String?, withDescription description: String?, withOkButtonText ok: String? = NSLocalizedString(Constants.LocalizationKeys.kGeneralOk, comment: ""), withCancelButtonText cancel: String? = NSLocalizedString(Constants.LocalizationKeys.kGeneralCancel, comment: ""), withPopupType type: PopupType?, withOkCompletion okCompletion: (() -> Void)?, withCancelCompletion cancelCompletion: (() -> Void)?) {
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            
            let storyboard = UIStoryboard(name: Constants.kStoryboardName, bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: Constants.kGenericPopupIdentifier) as! GenericPopupViewController
            controller.titleString = title
            controller.descriptionString = description
            controller.okButtonString = ok
            controller.cancelButtonString = cancel
            controller.okCompletion = okCompletion
            controller.cancelCompletion = cancelCompletion
            controller.popupType = type
            controller.modalPresentationStyle = .overCurrentContext
            topController.present(controller, animated: false, completion:nil)
        }
    }
    
    func hidePopup() {
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            topController.dismiss(animated: true, completion: nil)
        }
    }
    
    func showNoInternetConnection(_ completion: @escaping() -> Void) {
        PopupManager.sharedInstance.showPopup(withTitle: NSLocalizedString(Constants.LocalizationKeys.kGeneralErrorTitle, comment: ""), withDescription: NSLocalizedString(Constants.LocalizationKeys.kNoInternetConnection, comment: ""), withOkButtonText: NSLocalizedString(Constants.LocalizationKeys.kRetryButtonTitle, comment: ""), withCancelButtonText: NSLocalizedString(Constants.LocalizationKeys.kGeneralCancel, comment: ""), withPopupType: .error, withOkCompletion: {
            completion()
        }, withCancelCompletion: nil)
    }
    
    func showGeneralError() {
        PopupManager.sharedInstance.showPopup(withTitle: NSLocalizedString(Constants.LocalizationKeys.kGeneralErrorTitle, comment: ""), withDescription: NSLocalizedString(Constants.LocalizationKeys.kGeneralErrorMessage, comment: ""), withOkButtonText: NSLocalizedString(Constants.LocalizationKeys.kGeneralOk, comment: ""), withCancelButtonText: nil, withPopupType: .error, withOkCompletion: nil, withCancelCompletion: nil)
    }
    
}
