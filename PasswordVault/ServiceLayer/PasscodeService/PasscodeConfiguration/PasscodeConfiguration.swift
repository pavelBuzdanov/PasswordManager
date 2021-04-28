//
//  PasscodeConfiguration.swift
//  PasswordVault
//
//  Created by Pavel Buzdanov on 18.04.2021.
//

import Foundation


struct PasscodeLockConfiguration: PasscodeLockConfigurationType {
    
    let repository: PasscodeRepositoryType
    let passcodeLength = 4
    var isTouchIDAllowed = true
    let shouldRequestTouchIDImmediately = true
    let maximumIncorrectPasscodeAttempts = 4
    
    init(repository: PasscodeRepositoryType) {
        self.repository = repository
    }
    
    init() {
        self.repository = UserDefaultsPasscodeRepository()
    }
    
}
