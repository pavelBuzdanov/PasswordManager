//
//  SettingTableView.swift
//  PasswordVault
//
//  Created by Pavel Buzdanov on 27.04.2021.
//

import UIKit

class SettingTableView: UITableView {

    // MARK: - Properties
    var didSelectOption: ((SettingsModel) -> Void)?
 
    // MARK: - Constructor
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = UIColor.TableView.backgroundColor
        self.separatorColor = UIColor.TableView.separatorColor
        self.tableFooterView = UIView()
        self.isScrollEnabled = false
        self.register(SettingsTableViewCell.self, forCellReuseIdentifier: SettingsTableViewCell.identifier)
        delegate = self
        dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
    }
    
    
}

// MARK: - UITableViewDelegate
extension SettingTableView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 77
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let option = SettingsModel(rawValue: indexPath.row) else { return }
        self.didSelectOption?(option)
    }
    
}

// MARK: - UITableViewDataSource
extension SettingTableView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SettingsModel.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.identifier, for: indexPath) as? SettingsTableViewCell else { return UITableViewCell() }
        
        let cellData = SettingsModel(rawValue: indexPath.row)
        cell.cellData = cellData
        
        return cell
    }
    
}
