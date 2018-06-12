//
//  LogoutTableViewCell.swift
//  CompanyInventory-iOS
//
//  Created by Dorian Cizmar on 6/4/18.
//  Copyright © 2018 Dorian Cizmar. All rights reserved.
//

import UIKit

protocol LogoutTableViewCellDelegate: class {
    func buttonAction()
}

class LogoutTableViewCell: UITableViewCell {
    
    @IBOutlet weak var button: UIButton!
    weak var delegate: LogoutTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        applyStyles()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func applyStyles() {
        button.titleLabel?.font = ThemeManager.sharedInstance.defaultFont
        button.setTitleColor(ThemeManager.sharedInstance.logoutColor, for: .normal)
    }
    
    
    @IBAction func buttonAction(_ sender: Any) {
        delegate?.buttonAction()
    }
    
}
