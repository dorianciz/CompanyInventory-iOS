//
//  MoreItemTableViewCell.swift
//  CompanyInventory-iOS
//
//  Created by Dorian Cizmar on 6/3/18.
//  Copyright © 2018 Dorian Cizmar. All rights reserved.
//

import UIKit

protocol MoreItemDelegate: class {
    func switchAction(_ sender: MoreItemTableViewCell, _ uiSwitch: UISwitch?)
}

class MoreItemTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var switchButton: UISwitch!
    @IBOutlet weak var helperLabel: UILabel!
    
    weak var delegate: MoreItemDelegate?
    var indexPath: IndexPath!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func switchAction(_ sender: Any) {
        delegate?.switchAction(self, sender as? UISwitch)
    }
}
