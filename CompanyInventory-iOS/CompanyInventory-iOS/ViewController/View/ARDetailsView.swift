//
//  ARDetailsView.swift
//  CompanyInventory-iOS
//
//  Created by Dorian Cizmar on 7/6/18.
//  Copyright © 2018 Dorian Cizmar. All rights reserved.
//

import UIKit

class ARDetailsView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(withText text: String, withFrame frame: CGRect) {
        self.init(frame: frame)
        self.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        titleLabel.text = text
        titleLabel.font = UIFont(name: "Helvetica", size: 6)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        
        self.addSubview(titleLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
