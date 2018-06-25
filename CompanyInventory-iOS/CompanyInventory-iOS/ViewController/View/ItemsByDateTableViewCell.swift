//
//  ItemsByDateTableViewCell.swift
//  CompanyInventory-iOS
//
//  Created by Dorian Cizmar on 4/17/18.
//  Copyright © 2018 Dorian Cizmar. All rights reserved.
//

import UIKit

enum ItemPosition {
    case left
    case center
    case right
}

protocol ItemsByDateTableViewCellDelegate: class {
    func itemLongPressed(_ position: ItemPosition!, _ indexPath: IndexPath!)
    func deleteButtonTouched(_ position: ItemPosition!, _ indexPath: IndexPath!)
    func itemTouched(_ position: ItemPosition!, _ indexPath: IndexPath!)
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
    
    @IBOutlet weak var leftDeleteButton: UIButton!
    @IBOutlet weak var centerDeleteButton: UIButton!
    @IBOutlet weak var rightDeleteButton: UIButton!
    
    @IBOutlet weak var leftDeleteLeading: NSLayoutConstraint!
    @IBOutlet weak var leftDeleteTop: NSLayoutConstraint!
    @IBOutlet weak var leftDeleteBottom: NSLayoutConstraint!
    @IBOutlet weak var leftDeleteTrailing: NSLayoutConstraint!
    
    @IBOutlet weak var centerDeleteLeading: NSLayoutConstraint!
    @IBOutlet weak var centerDeleteBottom: NSLayoutConstraint!
    @IBOutlet weak var centerDeleteTrailing: NSLayoutConstraint!
    @IBOutlet weak var centerDeleteTop: NSLayoutConstraint!
    
    @IBOutlet weak var rightDeleteTop: NSLayoutConstraint!
    @IBOutlet weak var rightDeleteLeading: NSLayoutConstraint!
    @IBOutlet weak var rightDeleteTrailing: NSLayoutConstraint!
    @IBOutlet weak var rightDeleteBottom: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        applyStyles()
        hideAllItems()
        enableDeleteButtons(false)
        addGestures()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
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
        
        let longPress1 = UILongPressGestureRecognizer(target: self, action: #selector(leftLongPressed(_:)))
        leftImageView.addGestureRecognizer(longPress1)
        
        let longPress2 = UILongPressGestureRecognizer(target: self, action: #selector(centerLongPressed(_:)))
        centerImageView.addGestureRecognizer(longPress2)
        
        let longPress3 = UILongPressGestureRecognizer(target: self, action: #selector(rightLongPressed(_:)))
        rightImageView.addGestureRecognizer(longPress3)
        
        
    }
    
    private func hideAllItems() {
        leftViewContainer.isHidden = true
        centerViewContainer.isHidden = true
        rightViewContainer.isHidden = true
    }
    
    @objc func leftTapped() {
        delegate?.itemTouched(.left, indexPath)
    }
    
    @objc func centerTapped() {
        delegate?.itemTouched(.center, indexPath)
    }
    
    @objc func rightTapped() {
        delegate?.itemTouched(.right, indexPath)
    }
    
    @objc func leftLongPressed(_ recognizer: UILongPressGestureRecognizer) {
        if recognizer.state == .began {
            delegate?.itemLongPressed(.left, indexPath)
        }
    }
    
    @objc func centerLongPressed(_ recognizer: UILongPressGestureRecognizer) {
        if recognizer.state == .began {
            delegate?.itemLongPressed(.center, indexPath)
        }
    }
    
    @objc func rightLongPressed(_ recognizer: UILongPressGestureRecognizer) {
        if recognizer.state == .began {
            delegate?.itemLongPressed(.right, indexPath)
        }
    }
    
    @IBAction func leftDeleteAction(_ sender: Any) {
        delegate?.deleteButtonTouched(.left, indexPath)
    }
    
    @IBAction func centerDeleteAction(_ sender: Any) {
        delegate?.deleteButtonTouched(.center, indexPath)
    }
    
    @IBAction func rightDeleteAction(_ sender: Any) {
        delegate?.deleteButtonTouched(.right, indexPath)
    }
    
    func hideItem(_ position: ItemPosition) {
        
        switch position {
        case .left:
            self.leftViewContainer.layer.removeAllAnimations()
        case .center:
            self.centerViewContainer.layer.removeAllAnimations()
        case .right:
            self.rightViewContainer.layer.removeAllAnimations()
        }

        AnimationChainingFactory.sharedInstance.animation(withDuration: 0.5, withDelay: 0, withAnimations: {
            switch position {
            case .left:
                self.leftViewContainer.alpha = 0
            case .center:
                self.centerViewContainer.alpha = 0
            case .right:
                self.rightViewContainer.alpha = 0
            }
        }, withCompletion: {
            switch position {
            case .left:
                self.leftViewContainer.isHidden = true
            case .center:
                self.centerViewContainer.isHidden = true
            case .right:
                self.rightViewContainer.isHidden = true
            }
        }, withOptions: .transitionCrossDissolve).run()
    }
    
    func showDeleteButtons(_ show: Bool!) {
        AnimationChainingFactory.sharedInstance.animation(withDuration: 0.5, withDelay: 0, withAnimations: {
            self.leftImageView.layoutIfNeeded()
            self.leftDeleteLeading.constant = show ? -16 : -5
            self.leftDeleteTrailing.constant = show ? 8 : -5
            self.leftDeleteTop.constant = show ? -10 : 3
            self.leftDeleteBottom.constant = show ? 14 : 3
            self.leftViewContainer.layoutIfNeeded()
            
            self.centerImageView.layoutIfNeeded()
            self.centerDeleteLeading.constant = show ? -16 : -5
            self.centerDeleteTrailing.constant = show ? 8 : -5
            self.centerDeleteTop.constant = show ? -10 : 3
            self.centerDeleteBottom.constant = show ? 14 : 3
            self.centerViewContainer.layoutIfNeeded()
            
            self.rightImageView.layoutIfNeeded()
            self.rightDeleteLeading.constant = show ? -16 : -5
            self.rightDeleteTrailing.constant = show ? 8 : -5
            self.rightDeleteTop.constant = show ? -10 : 3
            self.rightDeleteBottom.constant = show ? 14 : 3
            self.rightViewContainer.layoutIfNeeded()
        }, withCompletion: {
            self.enableDeleteButtons(show)
        }, withOptions: UIViewAnimationOptions(rawValue: 0)).run()
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
    
    private func enableDeleteButtons(_ enable: Bool! = true) {
        leftDeleteButton.isEnabled = enable
        centerDeleteButton.isEnabled = enable
        rightDeleteButton.isEnabled = enable
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        ThemeManager.sharedInstance.roundCustomCorners(forView: leftResultLabel, withCorners: [.topLeft, .topRight], withCornerRadius: ThemeManager.sharedInstance.itemCornerRadius)
        ThemeManager.sharedInstance.roundCustomCorners(forView: centerResultLabel, withCorners: [.topLeft, .topRight], withCornerRadius: ThemeManager.sharedInstance.itemCornerRadius)
        ThemeManager.sharedInstance.roundCustomCorners(forView: rightResultLabel, withCorners: [.topLeft, .topRight], withCornerRadius: ThemeManager.sharedInstance.itemCornerRadius)
    }
    
}
