//
//  ItemsByDateHeaderSectionTableViewCell.swift
//  CompanyInventory-iOS
//
//  Created by Dorian Cizmar on 4/17/18.
//  Copyright © 2018 Dorian Cizmar. All rights reserved.
//

import UIKit

class ItemsByDateHeaderSectionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var separatorLineView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        separatorLineView.backgroundColor = ThemeManager.sharedInstance.generalGrayColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
