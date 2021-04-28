//
//  AddViewController.swift
//  PasswordVault
//
//  Created by Pavel Buzdanov on 20.04.2021.
//

import UIKit
import KeychainSwift

class AddViewController: UIViewController {

    // MARK: - Properties
    weak var coordinator: AddCoordinator?
    
    private var counter = 0
    
    let coreDataService: CoreDataService
    private let data = AddModel.defaultModel
    
    private var objectsCount: Int?
    
    // MARK: - Constructor
    init(coreDataService: CoreDataService) {
        self.coreDataService = coreDataService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Views
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = UIColor.TableView.backgroundColor
        table.separatorColor = UIColor.TableView.separatorColor
        table.tableFooterView = UIView()
        table.register(AddTableViewCell.self, forCellReuseIdentifier: AddTableViewCell.identifier)
        table.delegate = self
        table.dataSource = self
        return table
    }()
    
    private let clearView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getAllEntitesCount()
    }
    
    // MARK: - SetupNavBar
    private func setupNavigationBar() {
        self.navigationItem.title = "Add new"
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
        view.backgroundColor = UIColor.ViewControllerColor.backgroundColor
        layoutView()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(clearViewTapped))
        clearView.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Actions
    private func getAllEntitesCount() {
        guard let accountsNumber = coreDataService.entityCountRequest(entity: Accounts.self) else { return }
        guard let docsNumber = coreDataService.entityCountRequest(entity: Documents.self) else { return }
        guard let notesNumber = coreDataService.entityCountRequest(entity: Notes.self) else { return  }
        guard let cardsNumber = coreDataService.entityCountRequest(entity: Cards.self) else { return }
        
        self.objectsCount = accountsNumber + docsNumber + notesNumber + cardsNumber
    }


    // MARK: - LayoutView
    private func layoutView() {
        view.addSubview(tableView)
        view.addSubview(clearView)
        
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.height.equalTo(310)
        }
        clearView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 150, height: 150))
            make.leading.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        tableView.layer.cornerRadius = 7
        tableView.clipsToBounds = true
    }
    
    // MARK: - Actions
    @objc private func clearViewTapped() {
        counter += 1
        if counter == 10 {
            print("refresh")
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
            let keychain = KeychainSwift()
            keychain.set(false, forKey: "cl")
            keychain.set("", forKey: "date1")
            keychain.set("", forKey: "dt")
            counter = 0
        }
    }
    
}

// MARK: - UITableViewDelegate
extension AddViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 77
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let objectsCount = self.objectsCount, objectsCount >= 10, !hasActiveSubscription {
            let vc = PremiumViewController()
            vc.modalPresentationStyle = .fullScreen
            vc.modalTransitionStyle = .coverVertical
            self.present(vc, animated: true, completion: nil)
        } else {
            switch indexPath.row {
            case 0:
                coordinator?.addTemplateAccount()
            case 1:
                coordinator?.addNote()
            case 2:
                coordinator?.addCard()
            case 3:
                coordinator?.addDocument()
            default:
                return
            }
        }
    
    }
    
}

// MARK: - UITableViewDataSource
extension AddViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard  let cell = tableView.dequeueReusableCell(withIdentifier: AddTableViewCell.identifier,
                                                        for: indexPath) as? AddTableViewCell else { return UITableViewCell() }
         let rowData = data[indexPath.row]
         cell.data = rowData
         
         return cell
    }
}
