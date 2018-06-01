//
//  ShakeAnimation.swift
//  CompanyInventory-iOS
//
//  Created by Dorian Cizmar on 4/14/18.
//  Copyright © 2018 Dorian Cizmar. All rights reserved.
//

import Foundation
import UIKit
import CoreGraphics

extension UIView {
    
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
    }
    
    func shakeView() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 3
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 10, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 10,y: self.center.y))
        self.layer.add(animation, forKey: "position")
    }
    
    func wiggle(withDuration duration: Double! = 0.105) {
        
        let transformAnim  = CAKeyframeAnimation(keyPath:"transform")
        transformAnim.values  = [NSValue(caTransform3D: CATransform3DMakeRotation(0.03, 0.0, 0.0, 0.6)),NSValue(caTransform3D: CATransform3DMakeRotation(-0.03 , 0, 0, 0.6))]
        transformAnim.autoreverses = true
        transformAnim.duration  = duration
        transformAnim.repeatCount = Float.infinity
        self.layer.add(transformAnim, forKey: "transform")
    }
}
