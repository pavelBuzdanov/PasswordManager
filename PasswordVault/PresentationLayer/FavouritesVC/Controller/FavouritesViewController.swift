//
//  FavouritesViewController.swift
//  PasswordVault
//
//  Created by Pavel Buzdanov on 20.04.2021.
//

import UIKit

class FavouritesViewController: UIViewController {

    // MARK: - Properties
    private let coreDataService: CoreDataService
    // MARK: - Views
    private lazy var tableView = FavouritesTableView(coreDataService: coreDataService)
    
    private let placeholderImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "favplaceholder")
        return imageView
    }()
    
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.numberOfLines = 3
        label.font = Fonts.nunitoBold.of(size: 18)
        label.text = "Add an item to the favourites\nby clicking on the item heart icon"
        label.textColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.9490196078, alpha: 1)
        return label
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.favouritesDataSource.getData()
    }
    
    // MARK: - SetupNavBar
    private func setupNavigationBar() {
        self.navigationItem.title = "Favourites"
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.9490196078, alpha: 1) ,
            NSAttributedString.Key.font: Fonts.nunitoExtraBold.of(size: 20)
        ]
        
        self.navigationController?.navigationBar.backgroundColor = .clear
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    // MARK: - SetupView
    private func setupView() {
        layoutView()
        view.backgroundColor = UIColor.ViewControllerColor.backgroundColor
        
        NotificationCenter.default.addObserver(self, selector: #selector(hideTableView), name: NSNotification.Name(rawValue: "noFavData"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showTableView), name: NSNotification.Name(rawValue: "favData"), object: nil)
        
        tableView.didSelectDocuments = { [weak self] (document) in
            guard let self = self else { return }
            let vc = AddDocumentViewController(coreDataService: self.coreDataService)
            vc.savedData = document
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        tableView.didSelectAccount = { [weak self] (account) in
            guard let self = self else { return }
            let vc = AddAccountViewController(coreDataService: self.coreDataService)
            vc.savedData = account
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        tableView.didSelectNotes = { [weak self] (note) in
            guard let self = self else { return }
            let vc = AddNoteViewController(coreDataService: self.coreDataService)
            vc.savedData = note
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        tableView.didSelectCards = { [weak self] (card) in
            guard let self = self else { return }
            let vc = AddCardViewController(coreDataService: self.coreDataService)
            vc.savedData = card
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    // MARK: - LayoutView
    private func layoutView() {
        view.addSubview(tableView)
        view.addSubview(placeholderImageView)
        view.addSubview(placeholderLabel)
        
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.bottom.equalToSuperview()
        }
        
        placeholderImageView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 120, height: 120))
        }
        
        placeholderLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(placeholderImageView.snp.top).offset(-10)
            make.centerX.equalToSuperview()
        }
        
        tableView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        tableView.layer.cornerRadius = 7
        tableView.clipsToBounds = true
    }
    
    @objc private func hideTableView() {
        self.tableView.alpha = 0
        self.placeholderLabel.alpha = 1
        self.placeholderImageView.alpha = 1
    }
    
    @objc private func showTableView() {
        self.tableView.alpha = 1
        self.placeholderLabel.alpha = 0
        self.placeholderImageView.alpha = 0
    }

}
