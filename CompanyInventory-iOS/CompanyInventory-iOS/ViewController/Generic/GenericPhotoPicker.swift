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
    func photoHasBeenChoosen()
}

class GenericPhotoPicker: NSObject {

    var picker: UIImagePickerController!
    weak var delegate: GenericPhotoPickerDelegate?
    
    override init() {
        super.init()
        picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.sourceType = .camera
        picker.delegate = self
    }

    func changeSourceType(_ type: UIImagePickerControllerSourceType) {
        picker.sourceType = type
    }
    
}

extension GenericPhotoPicker: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.delegate?.photoHasBeenChoosen()
    }
}
