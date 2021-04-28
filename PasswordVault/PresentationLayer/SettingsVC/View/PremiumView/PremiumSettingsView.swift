//
//  PremiumSettingsView.swift
//  PasswordVault
//
//  Created by Pavel Buzdanov on 27.04.2021.
//

import UIKit
import SwiftyStoreKit

class PremiumSettingsView: UIView {

    // MARK: - Properties
    var premiumViewTapped: (() -> Void)?
    
    // MARK: - Views
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "settingPremium")
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .left
        label.font = Fonts.nunitoBold.of(size: 18)
        label.text = "Premium Activation"
        label.textColor = #colorLiteral(red: 0.1843137255, green: 0.5019607843, blue: 0.9294117647, alpha: 1)
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textColor = #colorLiteral(red: 0.7411764706, green: 0.7411764706, blue: 0.7411764706, alpha: 1)
        label.text = "Get full access"
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .left
        label.textColor = #colorLiteral(red: 0.1843137255, green: 0.5019607843, blue: 0.9294117647, alpha: 1)
        label.font = Fonts.nunitoBold.of(size: 18)
        return label
    }()
    
    // MARK: - Object lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = 10
        let gradLayer = self.gradient(colors: [#colorLiteral(red: 0.137254902, green: 0.1450980392, blue: 0.1568627451, alpha: 1), #colorLiteral(red: 0.1058823529, green: 0.1137254902, blue: 0.1254901961, alpha: 1)], startPoint: CGPoint(x: 0, y: 0),
                                           endPoint: CGPoint(x: 1, y: 1), opacity: 1.0, location: nil)
        gradLayer.cornerRadius = 10
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: 8).cgPath
        self.layer.shadowColor = #colorLiteral(red: 0.2274509804, green: 0.2274509804, blue: 0.2274509804, alpha: 0.25)
        self.layer.shadowRadius = 5
        self.layer.shadowOffset = .zero
        self.layer.shadowOpacity = 1.0
    }
    
    // MARK: - SetupView
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        layoutView()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        self.addGestureRecognizer(tapGesture)
    }
    
    private func setupPrice() {
        SwiftyStoreKit.retrieveProductsInfo([AppConstants.purchaseId]) { (result) in
            if let product = result.retrievedProducts.first {
                guard let price = product.localizedPrice else { return }
                guard let period = product.subscriptionPeriod?.localizedDescription else { return }
                self.priceLabel.text = "\(price) /per \(period)"
            } else if let invalidProductId = result.invalidProductIDs.first {
                print("Invalid product identifier: \(invalidProductId)")
            } else {
                print("Error: \(String(describing: result.error))")
            }
        }
    }
    
    func updateView() {
        if hasActiveSubscription {
            gestureRecognizers?.forEach({ self.removeGestureRecognizer($0) })
            priceLabel.isHidden = true
            subtitleLabel.text = "Full acccess"
            titleLabel.text = "Premium Activated"
        } else {
            subtitleLabel.text = "Get Full acccess"
            titleLabel.text = "Premium Activation"
            setupPrice()
        }
    }
    
    // MARK: - Actions
    @objc private func viewTapped() {
        Animator.scaleAnimation(view: self, duration: 0.3, scaleX: 0.96, scaleY: 0.96).handler()
        premiumViewTapped?()
    }
    
    // MARK: - LayoutView
    private func layoutView() {
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(priceLabel)
        
        imageView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 76, height: 88))
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(28)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(imageView.snp.trailing).offset(35)
            make.trailing.equalToSuperview().offset(-10)
            make.top.equalTo(imageView.snp.top)
        }
        
        subtitleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(imageView.snp.trailing).offset(35)
            make.trailing.equalToSuperview().offset(-10)
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
        }
        
        priceLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(imageView.snp.trailing).offset(35)
            make.trailing.equalToSuperview().offset(-10)
            make.top.equalTo(subtitleLabel.snp.bottom).offset(10)
        }
    }

}
