//
//  ViewController.swift
//  PasswordVault
//
//  Created by Pavel Buzdanov on 17.04.2021.
//

import UIKit


class CategoriesViewController: UIViewController {

    // MARK: - Properties
    private let coreDataService: CoreDataService
    
    // MARK: - Views
    private lazy var collectionView = CategotiesCollectionView(frame: .zero,
                                                          collectionViewLayout: UICollectionViewFlowLayout(),
                                                          coreDataService: coreDataService)
    
    
    // MARK: - Init
    init(coreDataService: CoreDataService) {
        self.coreDataService = coreDataService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - SetupNavBar
    private func setupNavigationBar() {
        self.navigationItem.title = "Categories"
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.9490196078, alpha: 1),
            NSAttributedString.Key.font: Fonts.nunitoExtraBold.of(size: 20)
        ]
        
        self.navigationItem.backButtonTitle = ""
        self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.9490196078, alpha: 1)
        self.navigationController?.navigationBar.backgroundColor = .clear
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.prefersLargeTitles = false
        
    }
    
    // MARK: - SetupView
    private func setupView() {
        layoutView()
        view.backgroundColor = UIColor.ViewControllerColor.backgroundColor
        
        collectionView.didSelectCategoty = { [weak self] (category) in
            self?.presentDetails(category: category)
        }
        
        if !UserDefaults.standard.bool(forKey: AppConstants.onboardingState) {
            let onboarding = OnboardingViewController()
            onboarding.modalTransitionStyle = .coverVertical
            onboarding.modalPresentationStyle = .fullScreen
            self.present(onboarding, animated: true, completion: nil)
        }
    }
    
    // MARK: - Present Detail VC
    private func presentDetails(category: Category) {
        let listVC = ListViewController(coreDataService: coreDataService, category: category)
        self.navigationController?.pushViewController(listVC, animated: true)
    }
    
    // MARK: - LayoutView
    private func layoutView() {
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
}

