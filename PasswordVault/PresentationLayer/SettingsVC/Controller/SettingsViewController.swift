//
//  SettingsViewController.swift
//  PasswordVault
//
//  Created by Pavel Buzdanov on 20.04.2021.
//

import UIKit
import MessageUI

class SettingsViewController: UIViewController {

    // MARK: - Properties
    // MARK: - Views
    private let premiumView = PremiumSettingsView()
    private let tableView = SettingTableView()
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        premiumView.updateView()
    }
    
    // MARK: - SetupNavBar
    private func setupNavigationBar() {
        self.navigationItem.title = "Settings"
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
        
        premiumView.premiumViewTapped = { [weak self] in
            self?.presentPremium() 
        }
        
        tableView.didSelectOption = { [weak self] (option) in
            switch option {
            case .changepin:
                self?.presentChangePin()
            case .help:
                self?.presentMail()
            case .privacy:
                self?.presentWebView(with: AppConstants.privacyURL)
            case .terms:
                self?.presentWebView(with: AppConstants.termsURL)
            }
        }
    }
    
    // MARK: - Transitions
    private func presentWebView(with url: String) {
        let webVC = WebViewController()
        webVC.urlString = url
        webVC.modalTransitionStyle = .crossDissolve
        webVC.modalPresentationStyle = .fullScreen
        self.present(webVC, animated: true, completion: nil)
    }
    
    private func presentPremium() {
        let vc = PremiumViewController()
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    private func presentMail() {
        if MFMailComposeViewController.canSendMail() {
            let mailVC = MFMailComposeViewController()
            mailVC.mailComposeDelegate = self
            mailVC.setSubject("Contact us! We will respond within a week")
            mailVC.setToRecipients([AppConstants.email])
            mailVC.navigationBar.tintColor = .systemBlue
            mailVC.setEditing(true, animated: true)
            
            present(mailVC, animated: true) {
                mailVC.becomeFirstResponder()
            }
        } else {
            self.showAlertWithMassage("Error", "Sorry,but you can't send emails")
        }
    }
    
    private func presentChangePin() {
        let configuration = PasscodeLockConfiguration()
        let vc = PasscodeLockViewController(state: .change, configuration: configuration)
        self.present(vc, animated: true, completion: nil)
    }

    // MARK: - LayoutView
    private func layoutView() {
        view.addSubview(premiumView)
        view.addSubview(tableView)
        
        premiumView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(15)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.height.equalTo(145)
        }
        
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(premiumView.snp.bottom).offset(50)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.height.equalTo(310)
        }
    }

}

// MARK: MFMailComposeViewControllerDelegate
extension SettingsViewController: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
