//
//  TemplateAccountViewController.swift
//  PasswordVault
//
//  Created by Pavel Buzdanov on 23.04.2021.
//

import UIKit

class TemplateAccountViewController: UIViewController {

    // MARK: - Properties
    weak var coordinator: AddCoordinator?
    // MARK: - Views
    private let tableView = TemplateAccountTableView()
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationBar()
    }
    
    // MARK: - SetupNavBar
    private func setupNavigationBar() {
        self.navigationItem.title = "Accounts"
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.9490196078, alpha: 1) ,
            NSAttributedString.Key.font: Fonts.nunitoExtraBold.of(size: 20)
        ]
        
        let rightButton = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addButtonTaped))
        self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.9490196078, alpha: 1)
        self.navigationItem.rightBarButtonItem = rightButton
        self.navigationController?.navigationBar.backgroundColor = .clear
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.prefersLargeTitles = false
        
    }
    
    // MARK: - SetupView
    private func setupView() {
        view.backgroundColor = UIColor.ViewControllerColor.backgroundColor
        layoutView()
        
        tableView.didSelectTemplate = {[weak self] (template) in
            self?.coordinator?.addAccount(with: template)
        }
    }
    // MARK: - LayoutView
    private func layoutView() {
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
    
    // MARK: - Action
    @objc private func addButtonTaped() {
        coordinator?.addAccount()
    }


}
