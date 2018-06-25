//
//  ItemsByDateHeaderSectionTableViewCell.swift
//  CompanyInventory-iOS
//
//  Created by Dorian Cizmar on 4/17/18.
//  Copyright © 2018 Dorian Cizmar. All rights reserved.
//

import UIKit

protocol SectionHeaderDelegate: class {
    func sectionHeaderTap(isCollapsed: Bool, section: Int)
}

class ItemsByDateHeaderSectionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var separatorLineView: UIView!
    
    weak var delegate: SectionHeaderDelegate?
    var isCollapsed: Bool?
    var section: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        separatorLineView.backgroundColor = ThemeManager.sharedInstance.generalGrayColor
        let tapGesture = UITapGestureRecognizer(target: contentView, action: #selector(test))
        contentView.addGestureRecognizer(tapGesture)
    }

    @objc func test() {
        print("selected")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func sectionTapAction(_ sender: Any) {
        if let isCollapsed = isCollapsed, let section = section {
            delegate?.sectionHeaderTap(isCollapsed: isCollapsed, section: section)
            self.isCollapsed = !isCollapsed
        }
    }
}
