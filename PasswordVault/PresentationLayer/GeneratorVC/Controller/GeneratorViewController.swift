//
//  GeneratorViewController.swift
//  PasswordVault
//
//  Created by Pavel Buzdanov on 20.04.2021.
//

import UIKit

class GeneratorViewController: UIViewController {

    // MARK: - Properties
    // MARK: - Views
    private let resultView = ResultView()
    private let optionsView = OptionsView()
    private let lockedView = LockedView()
    
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.resultView.password = self.optionsView.generatePassword()
        
        if !hasActiveSubscription {
            view.addSubview(lockedView)
            lockedView.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
            
            lockedView.activateDidTap = { [weak self] in
                let vc = PremiumViewController()
                vc.modalTransitionStyle = .coverVertical
                vc.modalPresentationStyle = .fullScreen
                self?.present(vc, animated: true, completion: nil)
            }
            
        } else {
            lockedView.removeFromSuperview()
        }
    }
    
    // MARK: - SetupNavBar
    private func setupNavigationBar() {
        self.navigationItem.title = "Passcode Generator"
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
        
        resultView.refreshTapped = { [weak self] in
            self?.resultView.password = self?.optionsView.generatePassword()
        }
    }

    // MARK: - LayoutView
    private func layoutView() {
        view.addSubview(resultView)
        view.addSubview(optionsView)
        
        resultView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(15)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.height.equalTo(165)
        }
        
        optionsView.snp.makeConstraints { (make) in
            make.top.equalTo(resultView.snp.bottom).offset(40)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-10)
        }
    }
}
