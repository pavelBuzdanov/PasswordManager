//
//  AddTableViewCell.swift
//  PasswordVault
//
//  Created by Pavel Buzdanov on 24.04.2021.
//

import UIKit

class AddTableViewCell: UITableViewCell {

    // MARK: - Properties
    static let identifier = "AddTableViewCell"
    
    var data: AddModel? {
        didSet {
            if let data = data {
                self.configureCell(with: data)
            }
        }
    }
    
    // MARK: - Views
    private let iconView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .left
        label.font = Fonts.nunitoBold.of(size: 20)
        label.textColor = #colorLiteral(red: 0.8784313725, green: 0.8784313725, blue: 0.8784313725, alpha: 1)
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textColor = #colorLiteral(red: 0.3098039216, green: 0.3098039216, blue: 0.3098039216, alpha: 1)
        return label
    }()
    
    // MARK: - Object lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


// MARK: - Private Extension
private extension AddTableViewCell {
    
    func setupCell() {
        layoutCell()
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
    }
    
    func configureCell(with data: AddModel) {
        iconView.image = UIImage(named: data.imageName)
        titleLabel.text = data.title
        subtitleLabel.text = data.subtitle
    }
    
    func layoutCell() {
        contentView.addSubview(iconView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        
        iconView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 40, height: 40))
            make.leading.equalToSuperview().offset(25)
            make.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(13)
            make.leading.equalTo(iconView.snp.trailing).offset(25)
            make.trailing.equalToSuperview().offset(-25)
        }
        
        subtitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(7)
            make.leading.equalTo(iconView.snp.trailing).offset(25)
            make.trailing.equalToSuperview().offset(-25)
        }
    }
    
}
