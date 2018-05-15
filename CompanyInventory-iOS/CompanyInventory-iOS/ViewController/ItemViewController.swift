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

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var beaconIdentifiedLabel: UILabel!
    @IBOutlet weak var beaconIdentifiedImage: UIImageView!
    
    var inventoryId: String?
    var inventoryItemByDateId: String?
    
    private let inventoryBrain = InventoryBrain()
    
    private var beaconId: String?
    private var image: UIImage? = #imageLiteral(resourceName: "no_image")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showBeaconIdentifiedViews(false)
        applyStyles()
        
    }

    private func applyStyles() {
        navigationItem.hidesBackButton = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveTapped))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(cancelTapped))
    }
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addPhoto(_ sender: Any) {
        
    }
    
    @objc func saveTapped() {
        let item = Item()
        item.beaconId = beaconId
        item.descriptionText = descriptionTextField.text
        item.name = nameTextField.text
        item.latitude = RealmOptional<Float>(12.0)
        item.longitude = RealmOptional<Float>(15.0)
        item.locationName = "Location name" // Should add text field for location name
        
        if let inventoryId = inventoryId {
            inventoryBrain.getAndUpdateLocalInventoryById(inventoryId, withRealmCompletion: { inventory in
                var foundInventoryByDate = false
                if let items = inventory?.items {
                    items.forEach { (inventoryByDate) in
                        if let id = inventoryByDate.id, let inventoryItemByDateId = self.inventoryItemByDateId {
                            if id == inventoryItemByDateId {
                                foundInventoryByDate = true
                                inventoryByDate.items?.append(item)
                            }
                        }
                    }
                    
                    if !foundInventoryByDate {
                        // Create new InventoryByDate
                        let inventoryByDate = InventoryItemByDate()
                        inventoryByDate.date = Date()
                        inventoryByDate.items!.append(item)
                        inventory!.items!.append(inventoryByDate)
                    }
                }
                
                self.inventoryBrain.saveInventory(inventory) { (response) in
                    if response == .success {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            })
            
            
        }
        
    }
    
    @objc func cancelTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? BeaconScanningViewController {
            destinationViewController.delegate = self
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
