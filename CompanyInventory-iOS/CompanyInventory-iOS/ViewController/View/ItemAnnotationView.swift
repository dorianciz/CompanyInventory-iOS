//
//  ItemAnnotationView.swift
//  CompanyInventory-iOS
//
//  Created by Dorian Cizmar on 6/13/18.
//  Copyright © 2018 Dorian Cizmar. All rights reserved.
//

import UIKit

class ItemAnnotationView: UIView {
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var descriptionTextLabel: UILabel!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func awakeFromNib() {
        super.awakeFromNib()
        applyStyles()
    }
    
    func applyStyles() {
        ThemeManager.sharedInstance.styleBoldLabel(titleLabel)
        ThemeManager.sharedInstance.styleDefaultLabel(locationLabel)
        ThemeManager.sharedInstance.styleDefaultLabel(descriptionTextLabel)
        self.layer.cornerRadius = ThemeManager.sharedInstance.buttonDefaultCornerRadius
        imageView.layer.cornerRadius = ThemeManager.sharedInstance.buttonDefaultCornerRadius
    }

}
