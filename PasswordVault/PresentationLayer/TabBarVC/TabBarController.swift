//
//  TabBarController.swift
//  PasswordVault
//
//  Created by Pavel Buzdanov on 17.04.2021.
//

import UIKit

class TabBarController: UITabBarController {
    
    private let coreDataManager = CoreDataManager()
    private lazy var addCoordinator = AddCoordinator(navigationController: UINavigationController(), coreDataSerivice: coreDataManager)
  
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    
    // MARK: - SetupTabBar
    private func setupTabBar() {
        self.tabBar.barTintColor = UIColor.TabBarColor.tabBarTintColor
        self.tabBar.tintColor = UIColor.TabBarColor.tabBarSelectedColor
        self.tabBar.unselectedItemTintColor = UIColor.TabBarColor.tabBarUnselectedColor
        
        addCoordinator.start()
        self.viewControllers = [createFirstViewController(),
                                createSecondViewController(),
                                addCoordinator.navigationController,
                                createFourthViewController(),
                                createFifthViewController()
        ]
        self.tabBar.items?.forEach({ $0.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0) })
    }
    
}

// MARK: - Create ViewControllers
extension TabBarController {
    
    private func createFirstViewController() -> UIViewController {
        let vc = UINavigationController(rootViewController: CategoriesViewController(coreDataService: coreDataManager))
        vc.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "categotiesIcon"), tag: 0)
        return vc
    }
    
    private func createSecondViewController() -> UIViewController {
        let vc = UINavigationController(rootViewController: FavouritesViewController(coreDataService: coreDataManager))
        vc.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "favouritesIcon"), tag: 1)
        return vc
    }
    
    private func  createFourthViewController() -> UIViewController {
        let vc = UINavigationController(rootViewController: GeneratorViewController())
        vc.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "generatorIcon"), tag: 3)
        return vc
    }
    
    private func createFifthViewController() -> UIViewController {
        let vc = UINavigationController(rootViewController: SettingsViewController())
        vc.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "settingsIcon"), tag: 4)
        return vc
    }
    
}
