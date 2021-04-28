//
//  ScrollView.swift
//  PasswordVault
//
//  Created by Pavel Buzdanov on 20.04.2021.
//

import UIKit

class ScrollView: UIScrollView {
    
    // MARK: - Views
    lazy var contentView : UIView = {
        let contentView = UIView(frame: .zero)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = .clear
        return contentView
    }()
    
    var multiplier: CGFloat? {
        didSet {
            layoutView()
        }
    }
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        layoutView()
        bounces = true
    }
    
    private func layoutView() {
        addSubview(contentView)
        
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: widthAnchor)
        ])
        
        let constraint = contentView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: multiplier ?? 2)
        constraint.priority = .defaultLow
        constraint.isActive = true
    }
}
