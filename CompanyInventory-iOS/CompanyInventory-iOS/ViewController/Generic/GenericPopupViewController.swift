//
//  GenericPopupViewController.swift
//  CompanyInventory-iOS
//
//  Created by Dorian Cizmar on 5/22/18.
//  Copyright © 2018 Dorian Cizmar. All rights reserved.
//

import UIKit

enum PopupType {
    case success
    case error
}

class GenericPopupViewController: UIViewController {

    @IBOutlet weak var popupContainerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var okButton: UIButton!
    
    var titleString: String?
    var descriptionString: String?
    var cancelButtonString: String?
    var okButtonString: String?
    var popupType: PopupType?
    var okCompletion: (() -> Void)?
    var cancelCompletion: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyStyles()
        fillStaticData()
    }
    
    private func applyStyles() {
        okButton.titleLabel?.font = ThemeManager.sharedInstance.defaultFont
        okButton.isHidden = okButtonString == nil
        okButton.layer.cornerRadius = ThemeManager.sharedInstance.buttonDefaultCornerRadius
        okButton.backgroundColor = ThemeManager.sharedInstance.generalBlueColor
        okButton.setTitleColor(ThemeManager.sharedInstance.inverseTextColor, for: .normal)
        
        cancelButton.titleLabel?.font = ThemeManager.sharedInstance.defaultFont
        cancelButton.isHidden = cancelButtonString == nil
        cancelButton.layer.cornerRadius = ThemeManager.sharedInstance.buttonDefaultCornerRadius
        cancelButton.backgroundColor = ThemeManager.sharedInstance.generalGrayColor
        cancelButton.setTitleColor(ThemeManager.sharedInstance.inverseTextColor, for: .normal)
        
        titleLabel.font = ThemeManager.sharedInstance.titleFont
        descriptionLabel.font = ThemeManager.sharedInstance.defaultFont
        titleLabel.text = titleString
        descriptionLabel.text = descriptionString
        
        popupContainerView.layer.cornerRadius = ThemeManager.sharedInstance.itemCornerRadius
        
        if let type = popupType {
            if type == .error {
                okButton.backgroundColor = ThemeManager.sharedInstance.errorColor
                return
            }
        }
    }
    
    private func fillStaticData() {
        okButton.setTitle(okButtonString, for: .normal)
        cancelButton.setTitle(cancelButtonString, for: .normal)
    }

    @IBAction func okButtonAction(_ sender: Any) {
        dismiss(animated: false, completion: okCompletion)
    }
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        dismiss(animated: false, completion: cancelCompletion)
    }
    
}
