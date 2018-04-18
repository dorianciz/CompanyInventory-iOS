//
//  ThemeManager.swift
//  CompanyInventory-iOS
//
//  Created by Dorian Cizmar on 3/27/18.
//  Copyright © 2018 Dorian Cizmar. All rights reserved.
//

import Foundation
import UIKit

final class ThemeManager {
    
    static let sharedInstance = ThemeManager()
    
    let brandColor = #colorLiteral(red: 1, green: 0.9865267873, blue: 0.4715276957, alpha: 1)
    let generalGrayColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
    
    func addShadow(toView view: UIView) {
        view.layer.shadowColor = UIColor.gray.cgColor
        view.layer.shadowOpacity = 0.8
        view.layer.shadowOffset = CGSize(width: -3, height: 3)
        view.layer.shadowRadius = 3
        view.layer.shadowPath = UIBezierPath(rect: view.bounds).cgPath
    }
    
    func createWhiteGradientLayer(_ view: UIView) {
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = view.bounds
        
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.white.cgColor]
        
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
}
