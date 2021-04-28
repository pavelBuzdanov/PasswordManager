//
//  ListViewController.swift
//  PasswordVault
//
//  Created by Pavel Buzdanov on 25.04.2021.
//

import UIKit
import CoreData
import Lottie

class ListViewController: UIViewController {
    
    // MARK: - Properties
    let category: Category
    var dataType: Any?
    
    // MARK: - Views
    let coreDataService: CoreDataService
    private var tableView: UITableView?
    
    private let placeholderImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "placeholderImage")
        return imageView
    }()
    
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.font = Fonts.nunitoBold.of(size: 18)
        label.text = "There is nothing here yet"
        label.textColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.9490196078, alpha: 1)
        return label
    }()
    
    private let addLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.font = Fonts.nunitoBold.of(size: 18)
        label.text = "Add new"
        label.textColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.9490196078, alpha: 1)
        return label
    }()
    
    private let animationView: AnimationView = {
        let animation = AnimationView(name: "arrow")
        animation.translatesAutoresizingMaskIntoConstraints = false
        animation.backgroundBehavior = .pauseAndRestore
        animation.loopMode = .repeat(.infinity)
        animation.contentMode = .scaleAspectFill
        animation.play()
        return animation
    }()
    
    
    // MARK: - Init
    init(coreDataService: CoreDataService, category: Category) {
        self.coreDataService = coreDataService
        self.category = category
        super.init(nibName: nil, bundle: nil)
        self.selectType(category: category)
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
        self.navigationItem.title = "Categories"
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.9490196078, alpha: 1),
            NSAttributedString.Key.font: Fonts.nunitoExtraBold.of(size: 20)
        ]
        
        let rightItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editButtonTaped))
        self.navigationItem.rightBarButtonItem = rightItem
        self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.9490196078, alpha: 1)
        self.navigationController?.navigationBar.backgroundColor = .clear
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    @objc private func  editButtonTaped() {
        if self.tableView?.isEditing == true {
            self.tableView?.setEditing(false, animated: true)
            self.navigationItem.rightBarButtonItem?.title = "Done"
        } else {
            self.tableView?.setEditing(true, animated: true)
            self.navigationItem.rightBarButtonItem?.title = "Edit"
        }
    }
    
    // MARK: - FIX IT
    func selectType(category: Category) {
        if category.account?.count != 0 {
            self.tableView = ListTableView<Accounts>(coreDataService: coreDataService, category: category)
            self.dataType = Accounts.self
            guard let tableView = self.tableView as? ListTableView<Accounts> else { return }
            tableView.didSelectAccount = { [weak self] (account) in
                guard let self = self else { return }
                let accVC = AddAccountViewController(coreDataService: self.coreDataService)
                accVC.savedData = account
                self.navigationController?.pushViewController(accVC, animated: true)
            }
        } else if category.notes?.count != 0 {
            self.dataType = Notes.self
            self.tableView = ListTableView<Notes>(coreDataService: coreDataService, category: category)
            
            guard let tableView = self.tableView as? ListTableView<Notes> else { return }
            tableView.didSelectNotes = { [weak self] (note) in
                guard let self = self else { return }
                let noteVC = AddNoteViewController(coreDataService: self.coreDataService)
                noteVC.savedData = note
                self.navigationController?.pushViewController(noteVC, animated: true)
            }
        } else if category.documents?.count != 0 {
            self.dataType = Documents.self
            self.tableView = ListTableView<Documents>(coreDataService: coreDataService, category: category)
            
            guard let tableView = self.tableView as? ListTableView<Documents> else { return }
            tableView.didSelectDocuments = { [weak self] (document) in
                guard let self = self else { return }
                let docVC = AddDocumentViewController(coreDataService: self.coreDataService)
                docVC.savedData = document
                self.navigationController?.pushViewController(docVC, animated: true)
            }
        } else if category.cards?.count != 0  {
            self.dataType = Cards.self
            self.tableView = ListTableView<Cards>(coreDataService: coreDataService, category: category)
            
            guard let tableView = self.tableView as? ListTableView<Cards> else { return }
            tableView.didSelectCards = { [weak self] (card) in
                guard let self = self else { return }
                let cardVC = AddCardViewController(coreDataService: self.coreDataService)
                cardVC.savedData = card
                self.navigationController?.pushViewController(cardVC, animated: true)
            }
        }
    }
    
    // MARK: - SetupView
    private func setupView() {
        layoutView()
        view.backgroundColor = UIColor.ViewControllerColor.backgroundColor
        
        NotificationCenter.default.addObserver(self, selector: #selector(hideTableView), name: NSNotification.Name(rawValue: "noListData"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showTableView), name: NSNotification.Name(rawValue: "listData"), object: nil)
    }
    
    // MARK: - LayoutView
    private func layoutView() {
        if let tableView = tableView {
            view.addSubview(tableView)
            
            tableView.snp.makeConstraints { (make) in
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
                make.leading.equalToSuperview().offset(15)
                make.trailing.equalToSuperview().offset(-15)
                make.bottom.equalToSuperview()
            }
            
            tableView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            tableView.layer.cornerRadius = 7
            tableView.clipsToBounds = true
        }
        view.addSubview(placeholderImageView)
        view.addSubview(placeholderLabel)
        view.addSubview(animationView)
        view.addSubview(addLabel)
        
        placeholderImageView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 170, height: 150))
            make.center.equalToSuperview()
        }
        
        placeholderLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(placeholderImageView.snp.bottom).offset(10)
        }
        
        animationView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 100, height: 100))
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
        }
        
        addLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(animationView.snp.top)
        }
        
    }
    
    // MARK: - Configure View
    @objc private func hideTableView() {
        self.tableView?.alpha = 0
        self.placeholderLabel.alpha = 1
        self.placeholderImageView.alpha = 1
        self.animationView.alpha = 1
        self.addLabel.alpha = 1
    }
    
    @objc private func showTableView() {
        self.tableView?.alpha = 1
        self.placeholderLabel.alpha = 0
        self.placeholderImageView.alpha = 0
        self.animationView.alpha = 0
        self.addLabel.alpha = 0
    }
}
