//
//  ListTableViewCell.swift
//  PasswordVault
//
//  Created by Pavel Buzdanov on 25.04.2021.
//

import UIKit
import CoreData

class ListTableViewCell: UITableViewCell {

    // MARK: - Properties
    static let identifier = "ListTableViewCell"
    
    var cellData: NSManagedObject? {
        didSet {
            if let celldata = cellData as? SavedData {
                configureCell(with: celldata)
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
    
    private let favouriteView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "favouriteIcon")
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = false
        label.textAlignment = .left
        label.font = Fonts.nunitoBold.of(size: 20)
        label.textColor = #colorLiteral(red: 0.8784313725, green: 0.8784313725, blue: 0.8784313725, alpha: 1)
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = false
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textColor = #colorLiteral(red: 0.3098039216, green: 0.3098039216, blue: 0.3098039216, alpha: 1)
        label.lineBreakMode = .byTruncatingTail
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
private extension ListTableViewCell {
    
    func setupCell() {
        layoutCell()
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
    }
    
    func configureCell(with data: SavedData) {
        titleLabel.text = data.title
        subtitleLabel.text = data.subtitle
        guard let imageName = data.image else { return }
        iconView.image = UIImage(named: imageName)
        if data.isFavourite {
            favouriteView.alpha = 1
        } else {
            favouriteView.alpha = 0
        }
    }
    
    func layoutCell() {
        contentView.addSubview(iconView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(favouriteView)
        
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
        
        favouriteView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 21, height: 21))
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-25)
        }
    }
    
}
