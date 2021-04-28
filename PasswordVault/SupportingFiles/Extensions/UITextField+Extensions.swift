//
//  UITextField+Extensions.swift
//  PasswordVault
//
//  Created by Pavel Buzdanov on 20.04.2021.
//

import UIKit

extension UITextField {
    
    func setGradient(startColor: UIColor, endColor: UIColor) {
        let gradient:CAGradientLayer = CAGradientLayer()
        gradient.colors = [startColor, endColor]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.frame = self.bounds
        self.layer.addSublayer(gradient)
    }
    
}
