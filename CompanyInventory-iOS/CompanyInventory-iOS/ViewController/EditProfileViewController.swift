//
//  EditProfileViewController.swift
//  CompanyInventory-iOS
//
//  Created by Dorian Cizmar on 6/7/18.
//  Copyright © 2018 Dorian Cizmar. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController {
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleLineView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var changePhotoButton: UIButton!
    @IBOutlet weak var nameAndSurnameTextField: UITextField!
    @IBOutlet weak var nameAndSurnameLineView: UIView!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var phoneLineView: UIView!
    @IBOutlet weak var changePasswordButton: UIButton!
    
    var ciUserToChange: CIUser?
    var ciUserBrain: CIUserBrain!
    
    private var documentManager: DocumentManager!
    private var image: UIImage = ThemeManager.sharedInstance.defaultItemImage
    private let photoMenu = GenericPhotoMenu()
    private let photoPicker = GenericPhotoPicker()
    private var imageChanged = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoMenu.delegate = self
        photoPicker.delegate = self
        photoPicker.picker.allowsEditing = true
        
        ciUserBrain = CIUserBrain()
        documentManager = DocumentManager()
        
        applyStyles()
        fillStaticData()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fillPersistanceData()
    }
    
    private func applyStyles() {
        ThemeManager.sharedInstance.styleHeaderLabel(titleLabel)
        titleLineView.backgroundColor = ThemeManager.sharedInstance.bottomLineColor
        nameAndSurnameLineView.backgroundColor = ThemeManager.sharedInstance.bottomLineColor
        phoneLineView.backgroundColor = ThemeManager.sharedInstance.bottomLineColor
        ThemeManager.sharedInstance.styleClearButton(button: changePasswordButton)
        ThemeManager.sharedInstance.styleDefaultButton(button: saveButton)
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = ThemeManager.sharedInstance.itemCornerRadius
        
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: NSLocalizedString(Constants.LocalizationKeys.kGeneralCancel, comment: ""), style: .done, target: self, action: #selector(cancelTapped))
    }
    
    private func fillStaticData() {
        titleLabel.text = NSLocalizedString(Constants.LocalizationKeys.kEditProfileTitle, comment: "")
        changePhotoButton.setTitle(NSLocalizedString(Constants.LocalizationKeys.kChoosePhoto, comment: ""), for: .normal)
        nameAndSurnameTextField.placeholder = NSLocalizedString(Constants.LocalizationKeys.kEditProfileNameAndSurnamePlaceholder, comment: "")
        phoneTextField.placeholder = NSLocalizedString(Constants.LocalizationKeys.kEditProfilePhonePlaceholder, comment: "")
        changePasswordButton.setTitle(NSLocalizedString(Constants.LocalizationKeys.kEditProfileChangePassword, comment:
            ""), for: .normal)
        saveButton.setTitle(NSLocalizedString(Constants.LocalizationKeys.kGeneralSave, comment: ""), for: .normal)
    }
    
    private func fillPersistanceData() {
        if let ciUser = ciUserToChange {
            image = documentManager.getImageFromDocument(withName: ciUser.photoPath) ?? ThemeManager.sharedInstance.defaultItemImage
            nameAndSurnameTextField.text = ciUser.name
            phoneTextField.text = ciUser.phoneNumber
        }
        
        profileImageView.image = image
    }
    
    @objc func cancelTapped() {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func changePhotoAction(_ sender: Any) {
        present(photoMenu.photoAlert, animated: true, completion: nil)
    }
    
    @IBAction func saveButtonAction(_ sender: Any) {
        ciUserBrain.saveUserProfileData(withUid: ciUserToChange?.uid, withUsername: ciUserToChange?.username, withNameAndSurname: nameAndSurnameTextField.text, withProfileImage: image, withPhoneNumber: phoneTextField.text) { (response) in
            switch response {
            case .success:
                self.navigationController?.popViewController(animated: true)
            case .noInternetConnection:
                PopupManager.sharedInstance.showNoInternetConnection {
                    self.saveButtonAction(self.saveButton)
                }
            case .missingInformations:
                PopupManager.sharedInstance.showPopup(withTitle: NSLocalizedString(Constants.LocalizationKeys.kMissingItemInfoTitle, comment: ""), withDescription: NSLocalizedString(Constants.LocalizationKeys.kMissingItemInfoMessage, comment: ""), withOkButtonText: NSLocalizedString(Constants.LocalizationKeys.kGeneralOk, comment: ""), withCancelButtonText: nil, withPopupType: .error, withOkCompletion: nil, withCancelCompletion: nil)
            case .error:
                PopupManager.sharedInstance.showGeneralError()
            default:
                break
            }
        }
    }
    
    @IBAction func changePasswordAction(_ sender: Any) {
        let passwordPopup = PopupManager.sharedInstance.showGenericPopup(withTitle: NSLocalizedString(Constants.LocalizationKeys.kChangePasswordTitle, comment: ""), withMessage: NSLocalizedString(Constants.LocalizationKeys.kChangePasswordMessage, comment: ""), withTextFieldsPlaceholders: [NSLocalizedString(Constants.LocalizationKeys.kChangePasswordNew, comment: ""), NSLocalizedString(Constants.LocalizationKeys.kChangePasswordRepeat, comment: "")], isPasswordType: true) { (passwords) in
            let newPassword = passwords[0]
            let repeatPassword = passwords[1]
            NavigationManager.sharedInstance.showLoader {
                self.ciUserBrain.changePassword(newPassword: newPassword, repeatedPassword: repeatPassword, withCompletion: { (response) in
                    NavigationManager.sharedInstance.hideLoader {
                        switch response {
                        case .success:
                            break
                            
                        case .noInternetConnection:
                            PopupManager.sharedInstance.showNoInternetConnection {
                                self.changePasswordAction(self)
                            }
                            
                        case .passwordsMissmatch:
                            PopupManager.sharedInstance.showPopup(withTitle: NSLocalizedString(Constants.LocalizationKeys.kGeneralWarning, comment: ""), withDescription: NSLocalizedString(Constants.LocalizationKeys.kPasswordsMissmatches, comment: ""), withOkButtonText: NSLocalizedString(Constants.LocalizationKeys.kGeneralOk, comment: ""), withCancelButtonText: nil, withPopupType: .error, withOkCompletion: nil, withCancelCompletion: nil)
                            
                        case .error:
                            PopupManager.sharedInstance.showGeneralError()
                            
                        default:
                            break
                        }
                    }
                })
            }
        }
        
        present(passwordPopup, animated: true, completion: nil)
    }
    
}

extension EditProfileViewController: GenericPhotoMenuDelegate {
    func takePhotoAction() {
        photoPicker.changeSourceType(.camera)
        present(photoPicker.picker, animated: true, completion: nil)
    }
    
    func changePhotoAction() {
        photoPicker.changeSourceType(.photoLibrary)
        present(photoPicker.picker, animated: true, completion: nil)
    }
    
    func cancelAction() {
        
    }
    
    func deleteAction() {
        self.image = ThemeManager.sharedInstance.defaultItemImage
        profileImageView.image = ThemeManager.sharedInstance.defaultItemImage
        imageChanged = false
        changePhotoButton.setTitle(NSLocalizedString(Constants.LocalizationKeys.kNewItemAddPhoto, comment: ""), for: .normal)
    }
}

extension EditProfileViewController: GenericPhotoPickerDelegate {
    func photoHasBeenChoosen(_ image: UIImage?) {
        print("Photo has been choosen - EditProfileViewController")
        if let choosenImage = image {
            self.image = choosenImage
            profileImageView.image = choosenImage
            imageChanged = true
            changePhotoButton.setTitle(NSLocalizedString(Constants.LocalizationKeys.kNewItemChangePhoto, comment: ""), for: .normal)
        } else {
            self.image = ThemeManager.sharedInstance.defaultItemImage
            profileImageView.image = ThemeManager.sharedInstance.defaultItemImage
            imageChanged = false
        }
    }
}
