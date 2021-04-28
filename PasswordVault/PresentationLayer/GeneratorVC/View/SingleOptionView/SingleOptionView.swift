//
//  SingleOptionView.swift
//  PasswordVault
//
//  Created by Pavel Buzdanov on 27.04.2021.
//

import UIKit

class SingleOptionView: UIView {
    
    // MARK: - Properties
    // MARK: - Views
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .left
        label.textColor = UIColor.Label.textColor
        label.font = .systemFont(ofSize: 20, weight: .medium)
        return label
    }()
    
    let swither: UISwitch = {
        let swither = UISwitch()
        swither.translatesAutoresizingMaskIntoConstraints = false
        swither.onTintColor = #colorLiteral(red: 0.1019607843, green: 0.1098039216, blue: 0.1215686275, alpha: 1)
        swither.isOn = true
        swither.thumbTintColor = #colorLiteral(red: 0.1843137255, green: 0.5019607843, blue: 0.9294117647, alpha: 1)
        return swither
    }()
    
    // MARK: - Object lifecycle
    init(frame: CGRect = .zero, title: String) {
        self.titleLabel.text = title
        super.init(frame: frame)
        setupView()
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
        addSubview(titleLabel)
        addSubview(swither)
        
        titleLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        swither.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
}
