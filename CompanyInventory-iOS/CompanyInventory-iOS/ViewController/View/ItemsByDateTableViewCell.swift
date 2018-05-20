//
//  ItemsByDateTableViewCell.swift
//  CompanyInventory-iOS
//
//  Created by Dorian Cizmar on 4/17/18.
//  Copyright © 2018 Dorian Cizmar. All rights reserved.
//

import UIKit

protocol ItemsByDateTableViewCellDelegate: class {
    func leftItemTouched(_ sender: ItemsByDateTableViewCell)
    func centerItemTouched(_ sender: ItemsByDateTableViewCell)
    func rightItemTouched(_ sender: ItemsByDateTableViewCell)
}

class ItemsByDateTableViewCell: UITableViewCell {

    weak var delegate: ItemsByDateTableViewCellDelegate?
    var indexPath: IndexPath!
    
    @IBOutlet weak var cellContentView: UIView!
    
    @IBOutlet weak var leftViewContainer: UIView!
    @IBOutlet weak var leftInfoLabel: UILabel!
    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var leftResultLabel: UILabel!
    
    @IBOutlet weak var centerViewContainer: UIView!
    @IBOutlet weak var centerImageView: UIImageView!
    @IBOutlet weak var centerInfoLabel: UILabel!
    @IBOutlet weak var centerResultLabel: UILabel!
    
    @IBOutlet weak var rightViewContainer: UIView!
    @IBOutlet weak var rightImageView: UIImageView!
    @IBOutlet weak var rightInfoLabel: UILabel!
    @IBOutlet weak var rightResultLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        applyStyles()
        hideAllItems()
        addGestures()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func addGestures() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(leftTapped))
        leftImageView.addGestureRecognizer(tap)
        leftImageView.isUserInteractionEnabled = true
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(centerTapped))
        centerImageView.addGestureRecognizer(tap2)
        centerImageView.isUserInteractionEnabled = true
        
        let tap3 = UITapGestureRecognizer(target: self, action: #selector(rightTapped))
        rightImageView.addGestureRecognizer(tap3)
        rightImageView.isUserInteractionEnabled = true
    }
    
    private func hideAllItems() {
        leftViewContainer.isHidden = true
        centerViewContainer.isHidden = true
        rightViewContainer.isHidden = true
    }
    
    @objc func leftTapped() {
        delegate?.leftItemTouched(self)
    }
    
    @objc func centerTapped() {
        delegate?.centerItemTouched(self)
    }
    
    @objc func rightTapped() {
        delegate?.rightItemTouched(self)
    }
    
    private func applyStyles() {
        leftImageView.layer.masksToBounds = true
        leftImageView.layer.cornerRadius = ThemeManager.sharedInstance.itemCornerRadius
        leftResultLabel.textColor = ThemeManager.sharedInstance.itemResultTextColor
        
        centerImageView.layer.masksToBounds = true
        centerImageView.layer.cornerRadius = ThemeManager.sharedInstance.itemCornerRadius
        centerResultLabel.textColor = ThemeManager.sharedInstance.itemResultTextColor
        
        rightImageView.layer.masksToBounds = true
        rightImageView.layer.cornerRadius = ThemeManager.sharedInstance.itemCornerRadius
        rightResultLabel.textColor = ThemeManager.sharedInstance.itemResultTextColor
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        ThemeManager.sharedInstance.roundCustomCorners(forView: leftResultLabel, withCorners: [.topLeft, .topRight], withCornerRadius: ThemeManager.sharedInstance.itemCornerRadius)
        ThemeManager.sharedInstance.roundCustomCorners(forView: centerResultLabel, withCorners: [.topLeft, .topRight], withCornerRadius: ThemeManager.sharedInstance.itemCornerRadius)
        ThemeManager.sharedInstance.roundCustomCorners(forView: rightResultLabel, withCorners: [.topLeft, .topRight], withCornerRadius: ThemeManager.sharedInstance.itemCornerRadius)
    }
    
}
