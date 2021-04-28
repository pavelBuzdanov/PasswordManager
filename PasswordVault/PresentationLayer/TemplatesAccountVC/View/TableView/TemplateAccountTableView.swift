//
//  TemplateAccountTableView.swift
//  PasswordVault
//
//  Created by Pavel Buzdanov on 23.04.2021.
//

import UIKit

class TemplateAccountTableView: UITableView {
    
    // MARK: - Properties
    var didSelectTemplate: ((TemplateAccountModel) -> Void)?

    private lazy var selfDataSource: TemplateAccountDataSource = {
       let dataSource = TemplateAccountDataSource()
        return dataSource
    }()
    
    // MARK: - Constructor
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor.TableView.backgroundColor
        separatorStyle = .singleLine
        separatorColor = UIColor.TableView.separatorColor
        register(TemplateAccountTableViewCell.self, forCellReuseIdentifier: TemplateAccountTableViewCell.identifier)
        delegate = self
        dataSource = selfDataSource
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension TemplateAccountTableView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 77
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let rowData = selfDataSource.data[indexPath.row]
        self.didSelectTemplate?(rowData)
    }
    
}
