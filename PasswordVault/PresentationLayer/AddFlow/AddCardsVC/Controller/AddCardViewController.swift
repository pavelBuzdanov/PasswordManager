//
//  AddCardViewController.swift
//  PasswordVault
//
//  Created by Pavel Buzdanov on 24.04.2021.
//

import UIKit
import CoreData

class AddCardViewController: UIViewController {
    
    // MARK: - Properties
    weak var coordinator: AddCoordinator?
    let coreDataService: CoreDataService
    
    var savedData: Cards? {
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
    
    private let addCardView = AddCardView()
    
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
        self.navigationItem.title = "Card"
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.9490196078, alpha: 1) ,
            NSAttributedString.Key.font: Fonts.nunitoExtraBold.of(size: 20)
        ]
        
        let rightButton = UIBarButtonItem(image: UIImage(named: "saveButton"), style: .plain, target: self, action: #selector(saveButtonTapped))
        let leftButton = UIBarButtonItem(image: UIImage(named: "backButton"), style: .plain, target: self, action: #selector(backButtonTapped))
        self.navigationItem.leftBarButtonItem = leftButton
        self.navigationItem.rightBarButtonItem = rightButton
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
    
    // MARK: - LayoutView
    private func layoutView() {
        view.addSubview(scrollView)
        
        scrollView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        scrollView.contentView.addSubview(addCardView)
        
        addCardView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.width.equalTo(view.frame.width)
            make.height.equalTo(view.frame.height + 300)
        }
    }
    
    // MARK: - Configure View
    private func configureViewWithSavedData(data: Cards) {
        self.addCardView.cardholderTextField.text = data.holderName
        self.addCardView.nameTextField.text = data.title
        self.addCardView.textView.text = data.note
        self.addCardView.cardNumberTextField.text = data.cardNumber
        self.addCardView.cardtypeTextField.text = data.cardType
        self.addCardView.textView.text = data.note
        self.addCardView.pinTextField.text = data.pin
        self.addCardView.dateTextField.text = data.date
        self.addCardView.cvvTextField.text = data.cvv
        self.isFavourite = data.isFavourite
        let rightButton = UIBarButtonItem(image: UIImage(named: "saveButton"), style: .plain, target: self, action: #selector(resaveButtonTapped))
        let imageName = data.isFavourite ? "favIcon" : "unfavIcon"
        favBarButton.image = UIImage(named: imageName)
        self.navigationItem.rightBarButtonItems = [rightButton, favBarButton]
    }
}

// MARK: - Private 
private extension AddCardViewController {
    
    @objc func saveButtonTapped() {
        coreDataService.performSave { (context) in
            guard let object = coreDataService.getObject(entity: Category.self, with: "Cards", compareKey: "title", context: context)?.first else { return }
            let card = buildObject(context: context)
            object.addToCards(card)
         }
        
        coordinator?.popToRoot()
    }
    
    @objc func resaveButtonTapped() {
        guard let savedData = self.savedData else { return }
            coreDataService.performUpdate{ (context) in
                guard let result = coreDataService.getObject(entity: Cards.self, with: "\(savedData.id!)", compareKey: "id", context: context)?.first else { return }
                result.isFavourite = self.isFavourite ?? false
                result.title = addCardView.nameTextField.text
                result.note = addCardView.textView.text
                result.pin = addCardView.pinTextField.text
                result.date = addCardView.dateTextField.text
                result.holderName = addCardView.cardholderTextField.text
                result.cardType = addCardView.cardtypeTextField.text
                result.cardNumber = addCardView.cardNumberTextField.text
                result.cvv = addCardView.cvvTextField.text
                result.subtitle = addCardView.cardNumberTextField.text
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
            guard let result = coreDataService.getObject(entity: Cards.self, with: "\(savedData.id!)",
                                                         compareKey: "id", context: context)?.first else { return }
            result.isFavourite = self.isFavourite ?? false
        }
    }
    
    @objc func backButtonTapped() {
        if coordinator != nil {
            coordinator?.navigationController.popViewController(animated: true)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    private func buildObject(context: NSManagedObjectContext) -> Cards {
        let title = addCardView.nameTextField.text
        let note = addCardView.textView.text
        let pin = addCardView.pinTextField.text
        let date = addCardView.dateTextField.text
        let holderName = addCardView.cardholderTextField.text
        let cardType = addCardView.cardtypeTextField.text
        let cardNumber = addCardView.cardNumberTextField.text
        let cvv = addCardView.cvvTextField.text
        
        let card = Cards(isFavourite: false, image: "cardPlaceholder", title: title, subtitle: cardNumber, note: note, pin: pin, date: date,
                        holderName: holderName, cardType: cardType, cvv: cvv, cardNumber: cardNumber, context: context)
        return card
    }
}
