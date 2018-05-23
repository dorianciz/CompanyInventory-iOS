//
//  ItemViewController.swift
//  CompanyInventory-iOS
//
//  Created by Dorian Cizmar on 4/16/18.
//  Copyright © 2018 Dorian Cizmar. All rights reserved.
//

import UIKit
import RealmSwift

class ItemViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var locationNameTextField: UITextField!
    @IBOutlet weak var beaconIdentifiedLabel: UILabel!
    @IBOutlet weak var beaconIdentifiedImage: UIImageView!
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var scanLabel: UILabel!
    
    var inventoryId: String?
    var inventoryItemByDateId: String?
    
    private let inventoryBrain = InventoryBrain()
    private let photoMenu = GenericPhotoMenu()
    private let photoPicker = GenericPhotoPicker()
    private var beaconId: String?
    private var image: UIImage! = ThemeManager.sharedInstance.defaultItemImage
    private var imageChanged = false
    private let locationManager = CLLocationManager()
    private var currentLocation: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoMenu.delegate = self
        photoPicker.delegate = self
        showBeaconIdentifiedViews(false)
        applyStyles()
        fillStaticLabels()
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
    }

    private func applyStyles() {
        navigationItem.hidesBackButton = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString(Constants.LocalizationKeys.kGeneralSave, comment: ""), style: .done, target: self, action: #selector(saveTapped))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: NSLocalizedString(Constants.LocalizationKeys.kGeneralCancel, comment: ""), style: .done, target: self, action: #selector(cancelTapped))
        itemImage.layer.cornerRadius = ThemeManager.sharedInstance.itemCornerRadius
    }
    
    private func fillStaticLabels() {
        titleLabel.text = NSLocalizedString(Constants.LocalizationKeys.kNewItemTitle, comment: "")
        nameTextField.placeholder = NSLocalizedString(Constants.LocalizationKeys.kGeneralNamePlaceholder, comment: "")
        descriptionTextField.placeholder = NSLocalizedString(Constants.LocalizationKeys.kGeneralDescriptionPlaceholder, comment: "")
        locationNameTextField.placeholder = NSLocalizedString(Constants.LocalizationKeys.kNewItemLocationNamePlaceholder, comment: "")
        addPhotoButton.setTitle(NSLocalizedString(Constants.LocalizationKeys.kNewItemAddPhoto, comment: ""), for: .normal)
        beaconIdentifiedLabel.text = NSLocalizedString(Constants.LocalizationKeys.kBeaconScannedSuccessfully, comment: "")
        scanLabel.text = NSLocalizedString(Constants.LocalizationKeys.kNewItemScan, comment: "")
    }
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addPhoto(_ sender: Any) {
        present(photoMenu.photoAlert, animated: true, completion: nil)
    }
    
    @objc func saveTapped() {
        let item = Item()
        item.beaconId = beaconId
        item.descriptionText = descriptionTextField.text
        item.name = nameTextField.text
        item.locationName = locationNameTextField.text
        item.photoLocalPath = imageChanged ? item.itemId : Constants.kDefaultItemImageName
        item.image = image
        
        if let location = currentLocation {
            item.latitude = RealmOptional<Float>(Float(location.latitude))
            item.longitude = RealmOptional<Float>(Float(location.longitude))
        }

        inventoryBrain.saveItem(item, toInventoryByDate: inventoryItemByDateId, toInventoryWithId: inventoryId) { (response) in
            if response == .success {
                self.navigationController?.popViewController(animated: true)
            } else if response == .missingInformations {
                self.present(PopupManager.sharedInstance.showInfoPopup(withTitle: NSLocalizedString(Constants.LocalizationKeys.kMissingItemInfoTitle, comment: ""), withMessage: NSLocalizedString(Constants.LocalizationKeys.kMissingItemInfoMessage, comment: "")), animated: true, completion: nil)
            } else if response == .error {
                self.present(PopupManager.sharedInstance.showInfoPopup(withTitle: NSLocalizedString(Constants.LocalizationKeys.kGeneralErrorTitle, comment: ""), withMessage: NSLocalizedString(Constants.LocalizationKeys.kSavingItemErrorMessage, comment: "")), animated: true, completion: nil)
            } else {
                self.present(PopupManager.sharedInstance.showInfoPopup(withTitle: NSLocalizedString(Constants.LocalizationKeys.kGeneralErrorTitle, comment: ""), withMessage: NSLocalizedString(Constants.LocalizationKeys.kGeneralErrorMessage, comment: "")), animated: true, completion: nil)
            }
        }
        
    }
    
    @objc func cancelTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func scanAction(_ sender: Any) {
        inventoryBrain.checkBluetoothConnection { (response) in
            if response == .bluetoothOn {
                self.performSegue(withIdentifier: Constants.kShowBeaconScanningSegue, sender: self)
            } else if response == .bluetoothError {
                PopupManager.sharedInstance.showPopup(withTitle: NSLocalizedString(Constants.LocalizationKeys.kBluetoothErrorTitle, comment: ""), withDescription: NSLocalizedString(Constants.LocalizationKeys.kBluetoothErrorDescription, comment: ""), withOkButtonText: NSLocalizedString(Constants.LocalizationKeys.kRetryButtonTitle, comment: ""), withCancelButtonText: NSLocalizedString(Constants.LocalizationKeys.kGeneralCancel, comment: ""), withPopupType: .error, withOkCompletion: {
                        NavigationManager.sharedInstance.showLoader {
                            DispatchQueue.main.asyncAfter(deadline: .now() + Constants.kWaitAfterBluetoothRetry, execute: {
                                NavigationManager.sharedInstance.hideLoader {
                                    self.scanAction(sender)
                                }
                            })
                        }
                    }, withCancelCompletion:nil)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? BeaconScanningViewController {
            destinationViewController.delegate = self
            destinationViewController.inventoryId = inventoryId
            destinationViewController.inventoryByDateId = inventoryItemByDateId
        }
    }
    
    private func showBeaconIdentifiedViews(_ show: Bool) {
        beaconIdentifiedLabel.isHidden = !show
        beaconIdentifiedImage.isHidden = !show
    }
    
}

extension ItemViewController: BeaconScanningViewControllerDelegate {
    func foundBeacon(withId id: String) {
        beaconId = id
        showBeaconIdentifiedViews(true)
    }
}

extension ItemViewController: GenericPhotoMenuDelegate {
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

extension ItemViewController: GenericPhotoPickerDelegate {
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

extension ItemViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = manager.location!.coordinate
    }
}
