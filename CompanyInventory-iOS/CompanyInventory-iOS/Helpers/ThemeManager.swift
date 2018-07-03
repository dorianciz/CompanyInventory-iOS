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
    
    let brandColor = #colorLiteral(red: 0.4620226622, green: 0.8382837176, blue: 1, alpha: 1)
    let generalGrayColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
    let generalBlueColor = #colorLiteral(red: 0, green: 0.5008062124, blue: 1, alpha: 1)
    let errorColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
    let textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    let inverseTextColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    let inventoryOpenedColor = #colorLiteral(red: 0.2176683843, green: 0.8194433451, blue: 0.2584097683, alpha: 1)
    let inventoryInProgressColor = #colorLiteral(red: 0, green: 0.5008062124, blue: 1, alpha: 1)
    let inventoryClosedColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
    let defaultItemImage = #imageLiteral(resourceName: "no_image")
    let itemCornerRadius: CGFloat = 4.0
    let buttonDefaultCornerRadius: CGFloat = 5.0
    let startAnimationGradientColor = #colorLiteral(red: 0, green: 0.5008062124, blue: 1, alpha: 1)
    let middleAnimationGradientColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
    let endAnimationGradientColor = #colorLiteral(red: 0, green: 0.5008062124, blue: 1, alpha: 1)
    let itemResultTextColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    let itemResultLabelSuccessColor = #colorLiteral(red: 0.2176683843, green: 0.8194433451, blue: 0.2584097683, alpha: 0.86)
    let itemResultLabelExpiredColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 0.86)
    let itemResultLabelMissingColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 0.86)
    let logoutColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
    let headerFont = UIFont(name: Constants.kDefaultBoldFontName, size: Constants.kHeaderFontSize)
    let titleFont = UIFont(name: Constants.kDefaultBoldFontName, size: Constants.kTitleFontSize)
    let defaultFont = UIFont(name: Constants.kDefaultFontName, size: Constants.kDefaultFontSize)
    let pdfRowFont = UIFont(name: Constants.kDefaultFontName, size: Constants.kPDFRowFontSize)
    let clearButtonColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
    let clearButtonBorderWidth:CGFloat = 1.0
    let clearButtonBorderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    let bottomLineColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    let gradientShadowColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 0.6025390625)
    let finishScanningButtonColor = #colorLiteral(red: 0.4620226622, green: 0.8382837176, blue: 1, alpha: 1)
    let itemResultColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    
    let itemResultShownTopConstraintValue: CGFloat = 15
    let itemResultHiddenTopConstraintValue: CGFloat = -3000
    let itemResultShownTrailingConstraint: CGFloat = 15
    let itemResultShownLeadingConstraint: CGFloat = 15
    let itemResultHiddenTrailingConstraint: CGFloat = -1015
    let itemResultHiddenLeadingConstraint: CGFloat = 1015
        
    func addShadow(toView view: UIView) {
        view.layer.shadowColor = UIColor.gray.cgColor
        view.layer.shadowOpacity = 0.8
        view.layer.shadowOffset = CGSize(width: -3, height: 3)
        view.layer.shadowRadius = 3
        view.layer.shadowPath = UIBezierPath(rect: view.bounds).cgPath
    }
    
    func addShadowToButton(button: UIButton) {
        button.layer.shadowColor = UIColor.gray.cgColor
        button.layer.shadowOpacity = 0.5
        button.layer.shadowOffset = CGSize(width: -1, height: 1)
        button.layer.shadowRadius = 2
        button.layer.shadowPath = UIBezierPath(rect: button.bounds).cgPath
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
    
    func styleDefaultButton(button: UIButton!) {
        button.layer.cornerRadius = buttonDefaultCornerRadius
        button.backgroundColor = generalBlueColor
        button.setTitleColor(inverseTextColor, for: .normal)
        button.titleLabel?.font = titleFont
    }
    
    func styleClearButton(button: UIButton!, color: UIColor = ThemeManager.sharedInstance.clearButtonBorderColor) {
        button.layer.cornerRadius = buttonDefaultCornerRadius
        button.backgroundColor = clearButtonColor
        button.setTitleColor(color, for: .normal)
        button.titleLabel?.font = defaultFont
        button.layer.borderWidth = clearButtonBorderWidth
        button.layer.borderColor = color.cgColor
    }
    
    func styleDefaultLabel(_ label: UILabel!) {
        label.font = ThemeManager.sharedInstance.defaultFont
        label.textColor = ThemeManager.sharedInstance.textColor
    }
    
    func styleBoldLabel(_ label: UILabel!) {
        label.font = ThemeManager.sharedInstance.titleFont
        label.textColor = ThemeManager.sharedInstance.textColor
    }
    
    func styleHeaderLabel(_ label: UILabel!) {
        label.font = ThemeManager.sharedInstance.headerFont
        label.textColor = ThemeManager.sharedInstance.textColor
    }
    
    func stylePDFRowLabel(_ label: UILabel!) {
        label.font = pdfRowFont
        label.layer.borderWidth = 1
        label.layer.borderColor = #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1)
    }
}
