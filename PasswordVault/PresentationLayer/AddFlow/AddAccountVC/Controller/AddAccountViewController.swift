//
//  AddAccountViewController.swift
//  PasswordVault
//
//  Created by Pavel Buzdanov on 20.04.2021.
//

import UIKit
import CoreData

class AddAccountViewController: UIViewController {
    
    // MARK: - Properties
    weak var coodinator: AddCoordinator?
    let coreDataService: CoreDataService
    
    var data: TemplateAccountModel? {
        didSet {
            if let data = data {
                setupView(with: data)
            }
        }
    }
    
    var savedData: Accounts? {
        didSet {
            if let savedData = savedData {
                configureViewWithSavedData(data: savedData)
            }
        }
    }
    
    var isFavourite: Bool? {
        didSet {
            if let isFavourite = isFavourite {
                favBarButton.image = isFavourite ? UIImage(named: "favIcon") : UIImage(named: "unfavIcon")
            }
        }
    }
    
    // MARK: - Init
    init(coreDataService: CoreDataService) {
        self.coreDataService = coreDataService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Views
    private lazy var scrollView: ScrollView = {
        let scrollView = ScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var favBarButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: nil, style: .plain, target: self, action: #selector(favButtonTapped))
        return button
    }()
    
    private let addAccountView = AddAccountView()
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationBar()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(scrollViewTapped))
        scrollView.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        scrollView.contentSize = CGSize(width: view.bounds.width, height: view.bounds.height * 2)
    }
    

    
    @objc func scrollViewTapped() {
        view.endEditing(true)
    }
    
    // MARK: - SetupNavBar
    private func setupNavigationBar() {
        self.navigationItem.title = "Account"
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.9490196078, alpha: 1) ,
            NSAttributedString.Key.font: Fonts.nunitoExtraBold.of(size: 20)
        ]
        
        if savedData == nil {
            let rightButton = UIBarButtonItem(image: UIImage(named: "saveButton"), style: .plain, target: self, action: #selector(saveButtonTapped))
            self.navigationItem.rightBarButtonItem = rightButton
        }
        let leftButton = UIBarButtonItem(image: UIImage(named: "backButton"), style: .plain, target: self, action: #selector(backButtonTapped))
        self.navigationItem.leftBarButtonItem = leftButton
        self.navigationController?.navigationBar.backgroundColor = .clear
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.prefersLargeTitles = false
        
    }
    
    // MARK: - SetupView
    private func setupView() {
        layoutView()
        view.backgroundColor = UIColor.ViewControllerColor.backgroundColor
    }
    
    private func setupView(with data: TemplateAccountModel) {
        addAccountView.nameTextField.text = data.title
        addAccountView.urlTextField.text = data.url
    }
    
    // MARK: - LayoutView
    private func layoutView() {
        view.addSubview(scrollView)
        
        scrollView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        scrollView.contentView.addSubview(addAccountView)
        
        addAccountView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.width.equalTo(view.frame.width)
            make.height.equalTo(view.frame.height + 100)
        }
    }
    
    // MARK: - Configure View
    private func configureViewWithSavedData(data: Accounts) {
        self.isFavourite = data.isFavourite
        self.addAccountView.nameTextField.text = data.title
        self.addAccountView.textView.text = data.notes
        self.addAccountView.passwordTextField.text = data.password
        self.addAccountView.urlTextField.text = data.url
        self.addAccountView.usernameTextField.text = data.username
        let rightButton = UIBarButtonItem(image: UIImage(named: "saveButton"), style: .plain, target: self, action: #selector(resaveButtonTapped))
        let imageName = data.isFavourite ? "favIcon" : "unfavIcon"
        favBarButton.image = UIImage(named: imageName)
        self.navigationItem.rightBarButtonItems = [rightButton, favBarButton]
    }
    
}

private extension AddAccountViewController {
    
    @objc func saveButtonTapped() {
        coreDataService.performSave { (context) in
            guard let object = coreDataService.getObject(entity: Category.self, with: "Accounts", compareKey: "title", context: context)?.first else { return }
            let account = self.buildObject(context: context)
            object.addToAccount(account)
            
        }
        coodinator?.popToRoot()
    }
    
    @objc func resaveButtonTapped() {
        guard let savedData = self.savedData else { return }
            coreDataService.performUpdate{ (context) in
                guard let result = coreDataService.getObject(entity: Accounts.self, with: "\(savedData.id!)", compareKey: "id", context: context)?.first else { return }
                result.isFavourite = self.isFavourite ?? false
                result.image = savedData.image ?? "accountPlaceholder"
                result.title = addAccountView.nameTextField.text
                result.notes = addAccountView.textView.text
                result.url = addAccountView.urlTextField.text
                result.password = addAccountView.passwordTextField.text
                result.username = addAccountView.usernameTextField.text
                result.subtitle = addAccountView.usernameTextField.text
            }
    }
    
    @objc private func favButtonTapped() {
        guard let savedData = self.savedData else { return }
        guard let isFavourite = self.isFavourite else { return }
        if isFavourite {
            self.isFavourite = false
        } else {
            self.isFavourite = true
        }
        
        coreDataService.performUpdate { (context) in
            guard let result = coreDataService.getObject(entity: Accounts.self, with: "\(savedData.id!)", compareKey: "id", context: context)?.first else { return }
            result.isFavourite = self.isFavourite ?? false
        }
    }
    
    private func buildObject(context: NSManagedObjectContext) -> Accounts {
        let title = addAccountView.nameTextField.text
        let note = addAccountView.textView.text
        let url = addAccountView.urlTextField.text
        let password = addAccountView.passwordTextField.text
        let username = addAccountView.usernameTextField.text
        let imageName = data?.imageName ?? "accountPlaceholder"
        
        let account = Accounts(isFavourite: false, image: imageName, title: title, subtitle: username, notes: note, password: password, url: url, username: username, context: context)
        
        return account
    }
    
    @objc func backButtonTapped() {
        if coodinator != nil {
            coodinator?.navigationController.popViewController(animated: true)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
}
