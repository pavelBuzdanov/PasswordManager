//
//  OnboardingCollectionViewCell.swift
//  PasswordVault
//
//  Created by Pavel Buzdanov on 27.04.2021.
//

import UIKit

class OnboardingCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    static let identifier = "OnboardingCollectionViewCell"
    
    var cellData: OnboardingModel? {
        didSet {
            if let cellData = cellData {
                configureCell(with: cellData)
            }
        }
    }
    
    // MARK: - Views
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let iconView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "onboardingIcon")
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.textColor = UIColor.Label.textColor
        label.font = Fonts.nunitoExtraBold.of(size: 28)
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.font = .systemFont(ofSize: 20, weight: .light)
        label.numberOfLines = 2
        label.textColor = UIColor.Label.sectionLabelColor
        return label
    }()
    
    // MARK: - Constructor
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private
private extension OnboardingCollectionViewCell {
    
    func setupCell(){
        layoutCell()
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
    }
    
    func layoutCell(){
        contentView.addSubview(imageView)
        contentView.addSubview(iconView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        
        imageView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 200, height: 236))
            make.centerX.equalToSuperview()
            make.bottom.equalTo(contentView.snp.centerY).offset(-10)
        }
        
        
        iconView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 57, height: 57))
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }
       
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(contentView.snp.centerY).offset(20)
        }
        
        subtitleLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.top.equalTo(titleLabel.snp.bottom).offset(17)
        }
    }
    
    func configureCell(with data: OnboardingModel) {
        titleLabel.text = data.title
        subtitleLabel.text = data.subtitle
        imageView.image = UIImage(named: data.imageName)
    }
    
}
