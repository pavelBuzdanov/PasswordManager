//
//  ResultView.swift
//  PasswordVault
//
//  Created by Pavel Buzdanov on 27.04.2021.
//

import UIKit

class ResultView: UIView {

    // MARK: - Properties
    var refreshTapped: (() -> Void)?
    
    var password: String? {
        didSet {
            resultLabel.text = password
        }
    }
    
    // MARK: - Views
    private let resultLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 24, weight: .medium)
        label.textColor = UIColor.Label.textColor
        label.text = "asdadasd"
        return label
    }()
    
    private let refreshButton: UIButton =  {
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "refreshButtonImage"), for: .normal)
        button.addTarget(self, action: #selector(refreshButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let copyButton: UIButton =  {
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "copyButtonImage"), for: .normal)
        button.addTarget(self, action: #selector(copyButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Object lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    // MARK: - SetupView
    private func setupView() {
        layoutView()
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    // MARK: - LayoutView
    private func layoutView() {
        addSubview(resultLabel)
        let stackView = UIStackView(arrangedSubviews: [refreshButton, copyButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 22
        stackView.distribution = .fillEqually
        addSubview(stackView)
        
        stackView.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-15)
            make.centerX.equalToSuperview()
        }
        
        resultLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.bottom.equalTo(stackView.snp.top).offset(-30)
        }
        
    }

}

// MARK: - Private
private extension ResultView {
    
    @objc func refreshButtonTapped() {
        self.refreshTapped?()
    }
    
    @objc func copyButtonTapped() {
        let text = resultLabel.text
        UIView.transition(with: resultLabel, duration: 1.0, options: .transitionCrossDissolve) {
            self.resultLabel.text = "Copied!"
        } completion: { (_) in
            UIView.transition(with: self.resultLabel, duration: 1.0, options: .transitionCrossDissolve) {
                self.resultLabel.text = text
            }
        }
        
        UIPasteboard.general.string = text
    }
    
}
