//
//  AddCoordinator.swift
//  PasswordVault
//
//  Created by Pavel Buzdanov on 21.04.2021.
//

import UIKit

class AddCoordinator: Coordinator {
    
    var childCoordinators = [Coordinator]()
    
    let coreDataService: CoreDataService
    var navigationController: UINavigationController
    
    // MARK: - Init
    init(navigationController: UINavigationController, coreDataSerivice: CoreDataService) {
        self.navigationController = navigationController
        self.coreDataService = coreDataSerivice
    }
    
    func start() {
        let vc = AddViewController(coreDataService: coreDataService)
        vc.coordinator = self
        vc.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "addIcon"), tag: 2)
        navigationController.pushViewController(vc, animated: false)
    }
    
    func addAccount(with template: TemplateAccountModel? = nil) {
        let vc = AddAccountViewController(coreDataService: coreDataService)
        vc.coodinator = self
        vc.data = template
        navigationController.pushViewController(vc, animated: true)
    }
    
    func addNote() {
        let vc = AddNoteViewController(coreDataService: coreDataService)
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func addCard() {
        let vc = AddCardViewController(coreDataService: coreDataService)
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func addDocument() {
        let vc = AddDocumentViewController(coreDataService: coreDataService)
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func addTemplateAccount() {
        let vc = TemplateAccountViewController()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    
    func popToRoot() {
        navigationController.popToRootViewController(animated: true)
    }
    
}
