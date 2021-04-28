//
//  Fonts.swift
//  PasswordVault
//
//  Created by Pavel Buzdanov on 19.04.2021.
//

import UIKit.UIFont

enum Fonts: String {
    
    case nunitoExtraBold = "Nunito-ExtraBold"
    case nunitoBold = "Nunito-Bold"
    
    func of(size: CGFloat) -> UIFont {
        guard let font = UIFont(name: self.rawValue, size: size) else { return UIFont.systemFont(ofSize: 18) }
        return font
    }
    
}
