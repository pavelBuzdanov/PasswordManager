//
//  PremiumViewController.swift
//  PasswordVault
//
//  Created by Pavel Buzdanov on 27.04.2021.
//

import UIKit
import SwiftyStoreKit
import ApphudSDK

class PremiumViewController: UIViewController {

    // MARK: - Properties
    // MARK: - Views
    private let backImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "premiumbackImage")
        return imageView
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        indicator.color = .white
        return indicator
    }()
    
    private let infoimageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "infoImage")
        return imageView
    }()
    
    private let subscriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = #colorLiteral(red: 0.7411764706, green: 0.7411764706, blue: 0.7411764706, alpha: 1)
        label.text = "Subscription automatically renews"
        return label
    }()
    
    
    private let restoreButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Restore", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.7411764706, green: 0.7411764706, blue: 0.7411764706, alpha: 1), for: .normal)
        button.titleLabel?.font = Fonts.nunitoExtraBold.of(size: 20)
        return button
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "closeIcon"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }()
    
    private let premiumLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.textColor = #colorLiteral(red: 0.1843137255, green: 0.5019607843, blue: 0.9294117647, alpha: 1)
        label.font =  Fonts.nunitoExtraBold.of(size: 36)
        label.text = "Premium"
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        return label
    }()
    
    private let purchaseButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Activate", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.1843137255, green: 0.5019607843, blue: 0.9294117647, alpha: 1), for: .normal)
        button.titleLabel?.font = Fonts.nunitoExtraBold.of(size: 20)
        return button
    }()
    
    private let iconView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "premiumIconVC")
        return imageView
    }()
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupPrice()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        purchaseButton.layer.cornerRadius = 8
        let gradLayer = purchaseButton.gradient(colors: [#colorLiteral(red: 0.137254902, green: 0.1450980392, blue: 0.1568627451, alpha: 1), #colorLiteral(red: 0.1058823529, green: 0.1137254902, blue: 0.1254901961, alpha: 1)], startPoint: CGPoint(x: 0, y: 0),
                                           endPoint: CGPoint(x: 1, y: 1), opacity: 1.0, location: nil)
        gradLayer.cornerRadius = 8
        purchaseButton.layer.shadowPath = UIBezierPath(roundedRect: purchaseButton.bounds, cornerRadius: 8).cgPath
        purchaseButton.layer.shadowColor = #colorLiteral(red: 0.2274509804, green: 0.2274509804, blue: 0.2274509804, alpha: 0.25)
        purchaseButton.layer.shadowRadius = 5
        purchaseButton.layer.shadowOffset = .zero
        purchaseButton.layer.shadowOpacity = 1.0
    }
    
    // MARK: - SetupView
    private func setupView() {
        layoutView()
        view.backgroundColor = UIColor.ViewControllerColor.backgroundColor
        
        restoreButton.addTarget(self, action: #selector(restoreButtonTapped), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        purchaseButton.addTarget(self, action: #selector(purchaseButtonTapped), for: .touchUpInside)
    }
    
    private func setupPrice() {
        SwiftyStoreKit.retrieveProductsInfo([AppConstants.purchaseId]) { (result) in
            if let product = result.retrievedProducts.first {
                guard let price = product.localizedPrice else { return }
                guard let period = product.subscriptionPeriod?.localizedDescription else { return }
                let bigFont = Fonts.nunitoExtraBold.of(size: 30)
                let regularFont =  Fonts.nunitoBold.of(size: 18)
                
                self.priceLabel.attributedText = "\(price) /per \(period)".withBoldText(boldPartsOfString: [price], font: regularFont, boldFont: bigFont, boldColor: #colorLiteral(red: 0.1843137255, green: 0.5019607843, blue: 0.9294117647, alpha: 1), textColor: #colorLiteral(red: 0.1843137255, green: 0.5019607843, blue: 0.9294117647, alpha: 1))
            } else if let invalidProductId = result.invalidProductIDs.first {
                print("Invalid product identifier: \(invalidProductId)")
            } else {
                print("Error: \(String(describing: result.error))")
            }
        }
    }
    
    // MARK: - LayoutView
    private func layoutView() {
        view.addSubview(backImageView)
        view.addSubview(closeButton)
        view.addSubview(restoreButton)
        view.addSubview(iconView)
        view.addSubview(premiumLabel)
        view.addSubview(purchaseButton)
        view.addSubview(subscriptionLabel)
        view.addSubview(priceLabel)
        view.addSubview(infoimageView)
        
        view.addSubview(activityIndicator)
        activityIndicator.center = view.center
        
        backImageView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.3)
        }
        
        purchaseButton.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-30)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.height.equalTo(80)
        }
        
        subscriptionLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(purchaseButton.snp.bottom).offset(10)
        }
        
        closeButton.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 20, height: 20))
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
        }
        
        restoreButton.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalTo(closeButton.snp.centerY)
        }
        
        premiumLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(closeButton.snp.bottom).offset(15)
        }
        
        iconView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 140, height: 140))
            make.centerX.equalToSuperview()
            make.top.equalTo(premiumLabel.snp.bottom).offset(10)
        }
        
        priceLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(iconView.snp.bottom).offset(15)
        }
        
        infoimageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 250, height: 133))
            make.top.equalTo(priceLabel.snp.bottom).offset(30)
        }
    }

}


// MARK: - Private
private extension PremiumViewController {
    
    @objc private func restoreButtonTapped() {
        activityIndicator.startAnimating()
        Apphud.restorePurchases{ [weak self] subscriptions, purchases, error in
            if Apphud.hasActiveSubscription(){
                self?.showAlertWithMassage("Success", "Purchase successfully restored ")
            } else {
                self?.showAlertWithMassage("Error", "Something went wrong. Please try again later")
            }
            self?.activityIndicator.stopAnimating()
        }
    }
    
    @objc private func closeButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func purchaseButtonTapped() {
        Animator.scaleAnimation(view: purchaseButton, duration: 0.3, scaleX: 0.96, scaleY: 0.96).handler()
        activityIndicator.startAnimating()
        Apphud.purchase(AppConstants.purchaseId) { [weak self] result in
            if let subscription = result.subscription, subscription.isActive(){
                self?.showAlertWithMassage("Success", "Thanks for shopping")
            } else {
                self?.showAlertWithMassage("Error", "Something went wrong. Please try again later")
            }
            self?.activityIndicator.stopAnimating()
        }
    }
    
}
