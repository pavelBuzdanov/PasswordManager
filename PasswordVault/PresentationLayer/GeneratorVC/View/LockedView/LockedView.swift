//
//  LockedView.swift
//  PasswordVault
//
//  Created by Pavel Buzdanov on 27.04.2021.
//

import UIKit

class LockedView: UIView {
    
    // MARK: - Properties
    var activateDidTap: (() -> Void)?
    // MARK: - Views
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "premiumIconVC")
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.text = "You need premium access"
        label.textColor = #colorLiteral(red: 0.1843137255, green: 0.5019607843, blue: 0.9294117647, alpha: 1)
        label.font = Fonts.nunitoExtraBold.of(size: 20)
        return label
    }()
    
    private let purchaseButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Activate", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.1843137255, green: 0.5019607843, blue: 0.9294117647, alpha: 1), for: .normal)
        button.titleLabel?.font = Fonts.nunitoExtraBold.of(size: 20)
        button.addTarget(self, action: #selector(purchaseButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let blurView: UIVisualEffectView = {
       let view = UIVisualEffectView()
        view.translatesAutoresizingMaskIntoConstraints = false
        let efffect = UIBlurEffect(style: .dark)
        view.effect = efffect
        return view
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
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    // MARK: - LayoutView
    private func layoutView() {
        addSubview(blurView)
        addSubview(purchaseButton)
        addSubview(titleLabel)
        addSubview(imageView)
        
        blurView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        purchaseButton.snp.makeConstraints { (make) in
            make.top.equalTo(snp.centerY).offset(50)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.height.equalTo(80)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(purchaseButton.snp.top).offset(-20)
        }
    
        imageView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 140, height: 140))
            make.centerX.equalToSuperview()
            make.bottom.equalTo(titleLabel.snp.top).offset(-20)
        }
    }

}

// MARK: - Private
private extension LockedView {
    
    @objc private func purchaseButtonTapped() {
        Animator.scaleAnimation(view: purchaseButton, duration: 0.5, scaleX: 0.96, scaleY: 0.96)
        activateDidTap?()
    }
    
}
