//
//  EditItemViewController.swift
//  CompanyInventory-iOS
//
//  Created by Dorian Cizmar on 6/26/18.
//  Copyright © 2018 Dorian Cizmar. All rights reserved.
//

import UIKit

class EditItemViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleLabelSeparatorView: UIView!
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var nameSeparatorView: UIView!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var descriptionSeparatorView: UIView!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var locationSeparatorView: UIView!
    @IBOutlet weak var saveButton: UIButton!
    
    var item: Item?
    var itemDetailsBrain: ItemDetailsBrain?
    var inventoryBrain: InventoryBrain?
    var inventoryId: String?
    var inventoryItemByDateId: String?
    
    private let photoMenu = GenericPhotoMenu()
    private let photoPicker = GenericPhotoPicker()
    private var image: UIImage! = ThemeManager.sharedInstance.defaultItemImage
    private var imageChanged = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        itemDetailsBrain = ItemDetailsBrain()
        inventoryBrain = InventoryBrain()
        photoMenu.delegate = self
        photoPicker.delegate = self
        
        applyStyles()
        fillStaticLabels()
        fillPersistanceData()
        // Do any additional setup after loading the view.
    }

    private func applyStyles() {
        ThemeManager.sharedInstance.styleHeaderLabel(titleLabel)
        titleLabelSeparatorView.backgroundColor = ThemeManager.sharedInstance.bottomLineColor
        nameSeparatorView.backgroundColor = ThemeManager.sharedInstance.bottomLineColor
        descriptionSeparatorView.backgroundColor = ThemeManager.sharedInstance.bottomLineColor
        locationSeparatorView.backgroundColor = ThemeManager.sharedInstance.bottomLineColor
        itemImage.clipsToBounds = true
        itemImage.layer.cornerRadius = ThemeManager.sharedInstance.itemCornerRadius
        ThemeManager.sharedInstance.styleDefaultButton(button: saveButton)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: NSLocalizedString(Constants.LocalizationKeys.kGeneralCancel, comment: ""), style: .done, target: self, action: #selector(cancelTapped))
    }
    
    private func fillStaticLabels() {
        titleLabel.text = NSLocalizedString(Constants.LocalizationKeys.kEditItemTitleLabel, comment: "")
        addPhotoButton.setTitle(NSLocalizedString(Constants.LocalizationKeys.kNewItemAddPhoto, comment: ""), for: .normal)
        nameTextField.placeholder = NSLocalizedString(Constants.LocalizationKeys.kGeneralNamePlaceholder, comment: "")
        descriptionTextField.placeholder = NSLocalizedString(Constants.LocalizationKeys.kGeneralDescriptionPlaceholder, comment: "")
        locationTextField.placeholder = NSLocalizedString(Constants.LocalizationKeys.kNewItemLocationNamePlaceholder, comment: "")
        saveButton.setTitle(NSLocalizedString(Constants.LocalizationKeys.kGeneralSave, comment: ""), for: .normal)
        itemImage.image = UIImage(named: Constants.kDefaultItemImageName)
    }
    
    private func fillPersistanceData() {
        nameTextField.text = item?.name
        descriptionTextField.text = item?.descriptionText
        locationTextField.text = item?.locationName
        itemImage.image = itemDetailsBrain?.getImage(forPath: item?.photoLocalPath)
    }
    
    @objc func cancelTapped() {
        navigationController?.dismiss(animated: true, completion: nil)
    }

    @IBAction func addPhotoAction(_ sender: Any) {
        present(photoMenu.photoAlert, animated: true, completion: nil)
    }
    
    @IBAction func saveAction(_ sender: Any) {
        let itemToSave = item?.copy() as! Item
        itemToSave.itemId = item?.itemId
        itemToSave.descriptionText = descriptionTextField.text
        itemToSave.name = nameTextField.text
        itemToSave.locationName = locationTextField.text
        itemToSave.photoLocalPath = imageChanged ? item?.itemId : Constants.kDefaultItemImageName
        itemToSave.image = image
        
        inventoryBrain?.updateItem(itemToSave, forInventoryId: inventoryId, forItemByDateId: inventoryItemByDateId, completion: { (response) in
            switch response {
            case .success:
                self.dismiss(animated: true, completion: nil)
            case .noInternetConnection:
                PopupManager.sharedInstance.showNoInternetConnection {
                    self.perform(#selector(self.saveAction(_:)))
                }
            case .error:
                PopupManager.sharedInstance.showGeneralError()
            default:
                break
            }
        })
        
    }
    
}

extension EditItemViewController: GenericPhotoMenuDelegate {
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
        itemImage.image = ThemeManager.sharedInstance.defaultItemImage
        imageChanged = false
        addPhotoButton.setTitle(NSLocalizedString(Constants.LocalizationKeys.kNewItemAddPhoto, comment: ""), for: .normal)
    }
}

extension EditItemViewController: GenericPhotoPickerDelegate {
    func photoHasBeenChoosen(_ image: UIImage?) {
        print("Photo has been choosen - ItemViewController")
        if let choosenImage = image {
            self.image = choosenImage
            itemImage.image = choosenImage
            imageChanged = true
            addPhotoButton.setTitle(NSLocalizedString(Constants.LocalizationKeys.kNewItemChangePhoto, comment: ""), for: .normal)
        } else {
            self.image = ThemeManager.sharedInstance.defaultItemImage
            itemImage.image = ThemeManager.sharedInstance.defaultItemImage
            imageChanged = false
        }
    }
}
