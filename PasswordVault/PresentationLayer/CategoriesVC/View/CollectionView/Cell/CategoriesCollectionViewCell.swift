//
//  CategoriesCollectionViewCell.swift
//  PasswordVault
//
//  Created by Pavel Buzdanov on 19.04.2021.
//

import UIKit

class CategoriesCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    static let identifier = "CategoriesCollectionViewCell"
    
    var cellData: Category? {
        didSet {
            if let cellData = cellData {
                configureCell(with: cellData)
            }
        }
    }
    
    private let cornerRadius: CGFloat = 10
    
    // MARK: - Views
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.textColor = #colorLiteral(red: 0.8784313725, green: 0.8784313725, blue: 0.8784313725, alpha: 1)
        return label
    }()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.textColor = #colorLiteral(red: 0.8784313725, green: 0.8784313725, blue: 0.8784313725, alpha: 1)
        return label
    }()
    
    var gradientLayer: CAGradientLayer?
    
    // MARK: - Constructor
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = cornerRadius
        gradientLayer?.cornerRadius = cornerRadius
        gradientLayer?.frame = contentView.bounds
        
        layer.shadowColor = #colorLiteral(red: 0.2274509804, green: 0.2274509804, blue: 0.2274509804, alpha: 1)
        layer.shadowOffset = .zero
        layer.shadowRadius = cornerRadius
        layer.shadowOpacity = 0.25
        layer.shadowPath = UIBezierPath(roundedRect: contentView.bounds, cornerRadius: cornerRadius).cgPath
    }
    
    // MARK: - SetupView
    private func setupCell() {
        layoutCell()
        
        gradientLayer = contentView.gradient(colors: [#colorLiteral(red: 0.1019607843, green: 0.1098039216, blue: 0.1215686275, alpha: 1), #colorLiteral(red: 0.137254902, green: 0.1450980392, blue: 0.1568627451, alpha: 1)],
                                             startPoint: CGPoint(x: 0, y: 0),
                                             endPoint: CGPoint(x: 1, y: 1),
                                             opacity: 1.0,
                                             location: nil)
    }
    
    // MARK: - ConfigureCell
    func configureCell(with data: Category) {
        guard let imageName = data.image else { return }
        imageView.image = UIImage(named: imageName)
        titleLabel.text = data.title
        guard let count = data.count else { return }
        countLabel.text = "\(count)"
    }
    
    // MARK: - LayoutCell
    private func layoutCell() {
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(countLabel)
        
        imageView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 31, height: 31))
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(20)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(20)
            make.top.equalTo(imageView.snp.bottom).offset(17)
        }
        
        countLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.trailing.equalToSuperview().offset(-20)
        }
    }
    
}
