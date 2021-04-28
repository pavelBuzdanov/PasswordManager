//
//  PasscodeLockPresenter.swift
//  PasscodeLock
//
//  Created by Yanko Dimitrov on 8/29/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import UIKit

open class PasscodeLockPresenter {
    
    private var mainWindow: UIWindow?
    
    private lazy var passcodeLockWindow: UIWindow = {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.accessibilityLabel = "PasscodeLock Window"
        window.makeKeyAndVisible()
        return window
    }()

    private let passcodeConfiguration: PasscodeLockConfigurationType
    open var isPasscodePresented = false
    public let passcodeLockVC: PasscodeLockViewController
    
    public init(mainWindow window: UIWindow?, configuration: PasscodeLockConfigurationType, viewController: PasscodeLockViewController) {
        mainWindow = window
        passcodeConfiguration = configuration
        
        passcodeLockVC = viewController
    }

    public convenience init(mainWindow window: UIWindow?, configuration: PasscodeLockConfigurationType, state: PasscodeLockViewController.LockState) {
        let passcodeLockVC = PasscodeLockViewController(state: state, configuration: configuration)
        self.init(mainWindow: window, configuration: configuration, viewController: passcodeLockVC)
    }
    
    open func present() {
        guard !isPasscodePresented else { return }
        isPasscodePresented = true
        mainWindow?.endEditing(true)
        moveWindowsToFront()
        passcodeLockWindow.isHidden = false
        let userDismissCompletionCallback = passcodeLockVC.dismissCompletionCallback
        
        passcodeLockVC.dismissCompletionCallback = { [weak self] in
            userDismissCompletionCallback?()
            self?.dismiss()
        }
        
        passcodeLockWindow.rootViewController = passcodeLockVC
        passcodeLockWindow.accessibilityViewIsModal = true
    }

    open func dismiss(animated: Bool = false) {
        isPasscodePresented = false
        if animated {
            animatePasscodeLockDismissal()
        } else {
            passcodeLockWindow.rootViewController = TabBarController()
        }
    }
    
    internal func animatePasscodeLockDismissal() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [],
            animations: { [weak self] in
             self?.passcodeLockWindow.alpha = 0
            }, completion: { [weak self] _ in
                self?.passcodeLockWindow.rootViewController = TabBarController()
                self?.passcodeLockWindow.alpha = 1
            }
        )
    }

    private func moveWindowsToFront() {
        let windowLevel = UIApplication.shared.windows.last?.windowLevel ?? UIWindow.Level.normal
        let maxWinLevel = max(windowLevel, .normal)
        passcodeLockWindow.windowLevel =  maxWinLevel + 1
    }
}
