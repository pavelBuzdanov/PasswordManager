//
//  Coordinator.swift
//  PasswordVault
//
//  Created by Pavel Buzdanov on 21.04.2021.
//

import UIKit

protocol Coordinator {
    
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    func start()
    
}
