//
//  FavouritesTableView.swift
//  PasswordVault
//
//  Created by Pavel Buzdanov on 26.04.2021.
//

import UIKit
import CoreData

class FavouritesTableView: UITableView {

    // MARK: - Properties
    let coreDataService: CoreDataService
    
    
    var didSelectAccount: ((Accounts) -> ())?
    var didSelectNotes: ((Notes) -> ())?
    var didSelectDocuments: ((Documents) -> ())?
    var didSelectCards: ((Cards) -> ())?
    
    lazy var favouritesDataSource: FavouritesDataSource = {
        let dataSource = FavouritesDataSource(coreDataService: coreDataService)
        dataSource.tableView = self
        return dataSource
    }()
    
    // MARK: - Construstor
    init(frame: CGRect = .zero, style: UITableView.Style = .plain, coreDataService: CoreDataService) {
        self.coreDataService = coreDataService
        super.init(frame: frame, style: style)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = UIColor.TableView.backgroundColor
        self.separatorColor = UIColor.TableView.separatorColor
        self.tableFooterView = UIView()
        self.register(FavouritesTableViewCell.self, forCellReuseIdentifier: FavouritesTableViewCell.identifier)
        delegate = self
        dataSource = favouritesDataSource
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
}

// MARK: - UITableViewDelegate
extension FavouritesTableView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = favouritesDataSource.data[indexPath.row]
       
        if let data = data as? Accounts {
            self.didSelectAccount?(data)
        } else if let data = data as? Documents {
            self.didSelectDocuments?(data)
        } else if let data = data as? Notes {
            self.didSelectNotes?(data)
        } else if let data = data as? Cards {
            self.didSelectCards?(data)
        } else {
            return
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 77
    }
}

