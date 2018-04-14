//
//  NavigationManager.swift
//  CompanyInventory-iOS
//
//  Created by Dorian Cizmar on 4/14/18.
//  Copyright © 2018 Dorian Cizmar. All rights reserved.
//

import Foundation
import UIKit

class NavigationManager {
    static let sharedInstance = NavigationManager()
    
    func showLoader(_ completion:@escaping() -> Void) {
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }

            let storyboard = UIStoryboard(name: Constants.kStoryboardName, bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: Constants.kLoaderViewControllerStoryboardId)
            controller.modalPresentationStyle = .overCurrentContext
            topController.present(controller, animated: false, completion: {
                completion()
            })
        }
    }
    
    func hideLoader(_ completion: @escaping() -> Void) {
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            topController.dismiss(animated: false) {
                completion()
            }
        }
    }
}
