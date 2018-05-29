//
//  ItemsByDateFooterTableViewCell.swift
//  CompanyInventory-iOS
//
//  Created by Dorian Cizmar on 5/24/18.
//  Copyright © 2018 Dorian Cizmar. All rights reserved.
//

import UIKit

protocol ItemsByDateFooterTableViewCellDelegate: class {
    func reportAction(_ sender: Any)
}

class ItemsByDateFooterTableViewCell: UITableViewCell {

    @IBOutlet weak var reportButton: UIButton!
    weak var delegate: ItemsByDateFooterTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ThemeManager.sharedInstance.styleDefaultButton(button: reportButton)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func reportButtonAction(_ sender: Any) {
        delegate?.reportAction(sender)
    }
    
}
