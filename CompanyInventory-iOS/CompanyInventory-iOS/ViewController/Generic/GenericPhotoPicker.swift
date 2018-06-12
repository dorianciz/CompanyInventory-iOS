//
//  GenericImagePicker.swift
//  CompanyInventory-iOS
//
//  Created by Dorian Cizmar on 5/16/18.
//  Copyright © 2018 Dorian Cizmar. All rights reserved.
//

import Foundation
import UIKit

protocol GenericPhotoPickerDelegate: class {
    func photoHasBeenChoosen(_ image: UIImage?)
}

class GenericPhotoPicker: NSObject {

    var picker: UIImagePickerController!
    weak var delegate: GenericPhotoPickerDelegate?
    private var photoHelper = PhotoHelper()
    
    override init() {
        super.init()
        picker = UIImagePickerController()
        picker.allowsEditing = false
        picker.sourceType = .camera
        picker.delegate = self
    }

    func changeSourceType(_ type: UIImagePickerControllerSourceType) {
        picker.sourceType = type
    }
    
}

extension GenericPhotoPicker: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        NavigationManager.sharedInstance.showLoader {
            let smallImage = info[UIImagePickerControllerOriginalImage] as? UIImage
            let largeImage = info[UIImagePickerControllerOriginalImage] as? UIImage
            let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage
            self.photoHelper.prepare(image: smallImage, withSize: Constants.kDefaultItemSmallPhotoSize)
            self.photoHelper.prepare(image: largeImage, withSize: Constants.kDefaultItemLargePhotoSize)
            picker.dismiss(animated: true, completion: {
                NavigationManager.sharedInstance.hideLoader {
                    self.delegate?.photoHasBeenChoosen(picker.allowsEditing ? editedImage : smallImage)
                }
            })
        }
        
    }
}
