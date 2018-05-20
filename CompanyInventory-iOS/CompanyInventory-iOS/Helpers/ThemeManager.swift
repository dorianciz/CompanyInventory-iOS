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
    let generalBlueColor = #colorLiteral(red: 0, green: 0.5008062124, blue: 1, alpha: 1)
    let inventoryOpenedColor = #colorLiteral(red: 0.2176683843, green: 0.8194433451, blue: 0.2584097683, alpha: 1)
    let inventoryClosedColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
    let defaultItemImage = #imageLiteral(resourceName: "no_image")
    let itemCornerRadius: CGFloat = 4.0
    let startAnimationGradientColor = #colorLiteral(red: 0, green: 0.5008062124, blue: 1, alpha: 1)
    let middleAnimationGradientColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
    let endAnimationGradientColor = #colorLiteral(red: 0, green: 0.5008062124, blue: 1, alpha: 1)
    let itemResultTextColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    let itemResultLabelSuccessColor = #colorLiteral(red: 0.2176683843, green: 0.8194433451, blue: 0.2584097683, alpha: 1)
    let itemResultLabelExpiredColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
    let itemResultLabelMissingColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
    
    
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
    
    func addGradientWithAnimation(toView view: UIView, withColors colors: [CGColor]) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.name = Constants.kAnimationLayerName
        gradientLayer.frame = view.bounds
        gradientLayer.colors = colors
        gradientLayer.locations = [0.0, 1.0];
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
        
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [0.0, 0.0, 0.5]
        animation.toValue = [0.5, 1.0, 1.0]
        animation.duration = 1.5
        animation.autoreverses = true
        animation.repeatCount = Float.infinity
        gradientLayer.add(animation, forKey: nil)
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func removeGradientLayerWithAnimation(fromView view: UIView) {
        view.layer.sublayers?.forEach({ (layer) in
            if layer.name == Constants.kAnimationLayerName {
                layer.removeFromSuperlayer()
            }
        })
    }
    
    func roundCustomCorners(forView view:UIView, withCorners corners: UIRectCorner, withCornerRadius cornerRadius: CGFloat) {
        let rectShape = CAShapeLayer()
        rectShape.bounds = view.frame
        rectShape.position = view.center
        rectShape.path = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)).cgPath
        view.layer.mask = rectShape
    }
    
}
