//
//  ItemsByDateFooterTableViewCell.swift
//  CompanyInventory-iOS
//
//  Created by Dorian Cizmar on 5/24/18.
//  Copyright © 2018 Dorian Cizmar. All rights reserved.
//

import UIKit

protocol ItemsByDateFooterTableViewCellDelegate: class {
    func reportAction(_ sender: Any, _ section: Int)
}

class ItemsByDateFooterTableViewCell: UITableViewCell {

    var section: Int?
    
    @IBOutlet weak var reportButton: UIButton!
    weak var delegate: ItemsByDateFooterTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ThemeManager.sharedInstance.styleDefaultButton(button: reportButton)
    }
    
    @IBAction func reportButtonAction(_ sender: Any) {
        guard let sectionNumber = section else {
            return
        }
        delegate?.reportAction(sender, sectionNumber)
    }
    
}
