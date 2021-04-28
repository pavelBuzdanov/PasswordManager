//
//  SettingsModel.swift
//  PasswordVault
//
//  Created by Pavel Buzdanov on 27.04.2021.
//

import Foundation

enum SettingsModel: Int, CaseIterable {
    
    case help
    case privacy
    case terms
    case changepin
    
    var icon: String {
        switch self {
        case .changepin: return "chagepinIcon"
        case .terms: return "termsIcon"
        case .privacy: return "privacyIcon"
        case .help: return "helpIcon"
        }
    }
    
    var title: String {
        switch self {
        case .changepin: return "Change Pin"
        case .terms: return "Terms Of Use"
        case .privacy: return "Privacy Policy"
        case .help: return "Help"
        }
    }
}
