//
//  AddNoteViewController.swift
//  PasswordVault
//
//  Created by Pavel Buzdanov on 24.04.2021.
//

import UIKit
import CoreData

class AddNoteViewController: UIViewController {

    // MARK: - Properties
    weak var coordinator: AddCoordinator?
    
    let coreDataService: CoreDataService
    
    
    var savedData: Notes? {
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
    
    // MARK: - Views
    private let addNoteView = AddNoteView()
    
    private lazy var favBarButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: nil, style: .plain, target: self, action: #selector(favButtonTapped))
        return button
    }()
    
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
    
    // MARK: - SetupNavBar
    private func setupNavigationBar() {
        self.navigationItem.title = "Note"
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
        view.backgroundColor = UIColor.ViewControllerColor.backgroundColor
        layoutView()
    }
    // MARK: - LayoutView
    private func layoutView() {
        view.addSubview(addNoteView)
        
        addNoteView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }

    // MARK: - Configure View
    private func configureViewWithSavedData(data: Notes) {
        self.addNoteView.nameTextField.text = data.title
        self.addNoteView.textView.text = data.text
        self.isFavourite = data.isFavourite
        let rightButton = UIBarButtonItem(image: UIImage(named: "saveButton"), style: .plain, target: self, action: #selector(resaveButtonTapped))
        let imageName = data.isFavourite ? "favIcon" : "unfavIcon"
        favBarButton.image = UIImage(named: imageName)
        self.navigationItem.rightBarButtonItems = [rightButton, favBarButton]
    }
 

}

private extension AddNoteViewController {
    
    @objc func saveButtonTapped() {
        coreDataService.performSave { (context) in
            guard let object = coreDataService.getObject(entity: Category.self, with: "Notes",
                                                         compareKey: "title", context: context)?.first else { return }
            let note = self.buildObject(context: context)
            object.addToNotes(note)
        }
        coordinator?.popToRoot()
    }
    
    @objc func resaveButtonTapped() {
        guard let savedData = self.savedData else { return }
            coreDataService.performUpdate{ (context) in
                guard let result = coreDataService.getObject(entity: Notes.self, with: "\(savedData.id!)", compareKey: "id", context: context)?.first else { return }
                result.isFavourite = self.isFavourite ?? false
                result.image = "notePlaceholder"
                result.title = addNoteView.nameTextField.text
                result.text = addNoteView.textView.text
                result.subtitle = addNoteView.textView.text
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
            guard let result = coreDataService.getObject(entity: Notes.self, with: "\(savedData.id!)",
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
    
    private func buildObject(context: NSManagedObjectContext) -> Notes {
        let name = addNoteView.nameTextField.text
        let note = addNoteView.textView.text
        let notes = Notes(isFavourite: false, image: "notePlaceholder", title: name, subtitle: note, text: note, context: context)
        return notes
    }
    
}

