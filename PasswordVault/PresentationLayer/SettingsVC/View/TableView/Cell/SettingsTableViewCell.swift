//
//  SettingsTableViewCell.swift
//  PasswordVault
//
//  Created by Pavel Buzdanov on 27.04.2021.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    static let identifier = "SettingsTableViewCell"
    
    var cellData: SettingsModel? {
        didSet {
            if let cellData = cellData {
                configureCell(with: cellData)
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
        label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        return label
    }()
    
    // MARK: - Constructor
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private
private extension SettingsTableViewCell {
    
    func setupCell() {
        layoutCell()
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        selectionStyle = .none
        tintColor = UIColor.blue
        accessoryType = .disclosureIndicator
 
    }
    
    func configureCell(with data: SettingsModel) {
        titleLabel.text = data.title
        imageView?.image = UIImage(named: data.icon)
    }
    
    func layoutCell() {
        contentView.addSubview(iconView)
        contentView.addSubview(titleLabel)
        
        iconView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 30, height: 30))
            make.leading.equalToSuperview().offset(21)
            make.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(iconView.snp.trailing).offset(30)
            make.trailing.equalToSuperview().offset(-30)
            make.centerY.equalToSuperview()
        }
    }
}
