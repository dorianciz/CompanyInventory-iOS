//
//  GenericPhotoMenu.swift
//  CompanyInventory-iOS
//
//  Created by Dorian Cizmar on 5/16/18.
//  Copyright © 2018 Dorian Cizmar. All rights reserved.
//

import Foundation
import UIKit

protocol GenericPhotoMenuDelegate: class {
    func takePhotoAction()
    func changePhotoAction()
    func cancelAction()
    func deleteAction()
}


class GenericPhotoMenu: NSObject {

    weak var delegate: GenericPhotoMenuDelegate?
    var photoAlert: UIAlertController!
    
    
    override init() {
        super.init()
        let photoAlertViewController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        photoAlertViewController.popoverPresentationController?.delegate = self
        photoAlertViewController.popoverPresentationController?.permittedArrowDirections = .up
        
        photoAlertViewController.addAction(takePhotoAction())
        photoAlertViewController.addAction(changePhotoAction())
        photoAlertViewController.addAction(cancelAction())
        photoAlertViewController.addAction(deletePhotoAction())
        
        self.photoAlert = photoAlertViewController
    }
    
    private func takePhotoAction() -> UIAlertAction {
        let takePhotoAction = UIAlertAction(title: "Take photo", style: .default) { (action) in
            self.delegate?.takePhotoAction()
        }
        return takePhotoAction
    }
    
    private func changePhotoAction() -> UIAlertAction {
        let changePhotoAction = UIAlertAction(title: "Change photo", style: .default) { (action) in
            self.delegate?.changePhotoAction()
        }
        return changePhotoAction
    }
    
    private func cancelAction() -> UIAlertAction {
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            self.delegate?.cancelAction()
        }
        return cancelAction
    }
    
    private func deletePhotoAction() -> UIAlertAction {
        let deletePhotoAction = UIAlertAction(title: "Delete photo", style: .destructive) { (action) in
            self.delegate?.deleteAction()
        }
        return deletePhotoAction
    }
    
}

extension GenericPhotoMenu: UIPopoverPresentationControllerDelegate {
    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        return true
    }
}
