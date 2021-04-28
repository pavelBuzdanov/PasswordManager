//
//  AddDocumentViewController.swift
//  PasswordVault
//
//  Created by Pavel Buzdanov on 24.04.2021.
//

import UIKit
import CoreData

class AddDocumentViewController: UIViewController {
    
    // MARK: - Properties
    weak var coordinator: AddCoordinator?
    let coreDataService: CoreDataService
    
    var savedData: Documents? {
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
    
    private let addDocumentView = AddDocumentView()
    
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
        self.navigationItem.title = "Document"
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
    
    // MARK: - ConfigureViewWithSaveData
    private func configureViewWithSavedData(data: Documents) {
        self.addDocumentView.addressTextField.text = data.adress
        self.addDocumentView.nameTextField.text = data.title
        self.addDocumentView.textView.text = data.note
        self.addDocumentView.phoneTextField.text = data.phone
        self.addDocumentView.firtnameField.text = data.firstName
        self.addDocumentView.lastnameField.text = data.lastName
        self.addDocumentView.emailTextField.text = data.email
        self.addDocumentView.jobTextField.text = data.job
        self.addDocumentView.birthdayField.text = data.birthday
        self.isFavourite = data.isFavourite
        let rightButton = UIBarButtonItem(image: UIImage(named: "saveButton"), style: .plain, target: self, action: #selector(resaveButtonTapped))
        let imageName = data.isFavourite ? "favIcon" : "unfavIcon"
        favBarButton.image = UIImage(named: imageName)
        self.navigationItem.rightBarButtonItems = [rightButton, favBarButton]
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
        scrollView.contentView.addSubview(addDocumentView)
        
        
        addDocumentView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.width.equalTo(view.frame.width)
            make.height.equalTo(view.frame.height + 300)
        }
        scrollView.multiplier = 2.2
    }
    
}

// MARK: - Private Extension
private extension AddDocumentViewController {
    
    @objc func saveButtonTapped() {
   
    
        coreDataService.performSave { (context) in
            guard let object = coreDataService.getObject(entity: Category.self, with: "Documents", compareKey: "title", context: context)?.first else { return }
            let document = buildObject(context: context)
            object.addToDocuments(document)
         }
        coordinator?.popToRoot()
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
            guard let result = coreDataService.getObject(entity: Documents.self, with: "\(savedData.id!)",
                                                         compareKey: "id", context: context)?.first else { return }
            result.isFavourite = self.isFavourite ?? false
        }
    }
    
    @objc func resaveButtonTapped() {
        guard let savedData = self.savedData else { return }
            coreDataService.performUpdate{ (context) in
                guard let result = coreDataService.getObject(entity: Documents.self, with: "\(savedData.id!)", compareKey: "id", context: context)?.first else { return }
                result.isFavourite = self.isFavourite ?? false
                result.title = addDocumentView.nameTextField.text
                result.note = addDocumentView.textView.text
                result.phone = addDocumentView.phoneTextField.text
                result.birthday = addDocumentView.birthdayField.text
                result.firstName = addDocumentView.firtnameField.text
                result.lastName = addDocumentView.lastnameField.text
                result.job = addDocumentView.jobTextField.text
                result.adress = addDocumentView.addressTextField.text
                result.subtitle = addDocumentView.firtnameField.text
            }
    }
   
    @objc func backButtonTapped() {
        if coordinator != nil {
            coordinator?.navigationController.popViewController(animated: true)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    private func buildObject(context: NSManagedObjectContext) -> Documents {
        let title = addDocumentView.nameTextField.text
        let note = addDocumentView.textView.text
        let phone = addDocumentView.phoneTextField.text
        let date = addDocumentView.birthdayField.text
        let firstName = addDocumentView.firtnameField.text
        let lastName = addDocumentView.lastnameField.text
        let job = addDocumentView.jobTextField.text
        let adress = addDocumentView.addressTextField.text
        
        let doc = Documents(isFavourite: false, image: "documentPlaceholder", title: title, subtitle: firstName, note: note, phone: phone,
                             firstName: firstName, lastName: lastName, job: job, birthday: date, adress: adress, context: context)
        return doc
    }
    
}

