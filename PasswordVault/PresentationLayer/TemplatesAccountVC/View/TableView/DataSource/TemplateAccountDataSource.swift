//
//  TemplateAccountDataSource.swift
//  PasswordVault
//
//  Created by Pavel Buzdanov on 23.04.2021.
//

import UIKit


class TemplateAccountDataSource: NSObject, UITableViewDataSource {
    
    // MARK: - Properties
    let data = TemplateAccountModel.defaultModels
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       guard  let cell = tableView.dequeueReusableCell(withIdentifier: TemplateAccountTableViewCell.identifier,
                                                       for: indexPath) as? TemplateAccountTableViewCell else { return UITableViewCell() }
        let rowData = data[indexPath.row]
        cell.data = rowData
        
        return cell
    }
    
}
