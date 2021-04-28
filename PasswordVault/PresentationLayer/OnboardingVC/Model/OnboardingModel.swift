//
//  OnboardingModel.swift
//  PasswordVault
//
//  Created by Pavel Buzdanov on 27.04.2021.
//

import Foundation


struct OnboardingModel {
    
    let title: String
    let subtitle: String
    let imageName: String
}

extension OnboardingModel {
    
    static let defaultModel = [
       OnboardingModel(title: "Secure", subtitle: "Your privacy is valued. Protect yourself from data\n breaches and hacking", imageName: "firstOnboarding"),
        OnboardingModel(title: "Simple and Easy", subtitle: "Easy to navigate and use", imageName: "secondOnboarding"),
        OnboardingModel(title: "Accessibility", subtitle: "Access anytime, anywhere.\nInstant authorization and permanent access to data", imageName: "thirdOnboarding")
    ]
    
}
