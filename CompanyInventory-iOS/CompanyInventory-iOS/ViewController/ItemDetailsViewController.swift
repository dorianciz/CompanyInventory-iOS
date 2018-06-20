//
//  ItemDetailsViewController.swift
//  CompanyInventory-iOS
//
//  Created by Dorian Cizmar on 5/29/18.
//  Copyright © 2018 Dorian Cizmar. All rights reserved.
//

import UIKit

class ItemDetailsViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleSeparatorView: UIView!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var nameValueLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var descriptionValueLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var locationValueLabel: UILabel!
    @IBOutlet weak var beaconIdLabel: UILabel!
    @IBOutlet weak var beaconIdValueLabel: UILabel!
    
    let itemDetailsBrain = ItemDetailsBrain()
    var item: Item?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyStyles()
        fillStaticLabels()
        editInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fillPersistanceData()
    }
    
    private func applyStyles() {
        ThemeManager.sharedInstance.styleHeaderLabel(titleLabel)
        ThemeManager.sharedInstance.styleBoldLabel(nameValueLabel)
        ThemeManager.sharedInstance.styleBoldLabel(descriptionLabel)
        ThemeManager.sharedInstance.styleBoldLabel(locationLabel)
        ThemeManager.sharedInstance.styleBoldLabel(beaconIdLabel)
        ThemeManager.sharedInstance.styleDefaultLabel(descriptionValueLabel)
        ThemeManager.sharedInstance.styleDefaultLabel(locationValueLabel)
        ThemeManager.sharedInstance.styleDefaultLabel(beaconIdValueLabel)
        titleSeparatorView.backgroundColor = ThemeManager.sharedInstance.generalGrayColor
        itemImageView.clipsToBounds = true
        itemImageView.layer.cornerRadius = ThemeManager.sharedInstance.itemCornerRadius
    }
    
    private func fillStaticLabels() {
        titleLabel.text = NSLocalizedString(Constants.LocalizationKeys.kItemDetails, comment: "")
        descriptionLabel.text = NSLocalizedString(Constants.LocalizationKeys.kDescriptionLabel, comment: "")
        locationLabel.text = NSLocalizedString(Constants.LocalizationKeys.kLocationLabel, comment: "")
        beaconIdLabel.text = NSLocalizedString(Constants.LocalizationKeys.kBeaconIdLabel, comment: "")
    }
    
    private func fillPersistanceData() {
        nameValueLabel.text = item!.name
        descriptionValueLabel.text = item!.descriptionText
        locationValueLabel.text = item!.locationName
        beaconIdValueLabel.text = item!.beaconId
        itemImageView.image = itemDetailsBrain.getImage(forPath: item!.photoLocalPath)
    }
    
    private func editInfo() {
        guard let status = item?.status, status == .none else {
            return
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString(Constants.LocalizationKeys.kGeneralEdit, comment: ""), style: .done, target: self, action: #selector(editTapped))
    }
    
    @objc func editTapped() {
        
    }
    
}
