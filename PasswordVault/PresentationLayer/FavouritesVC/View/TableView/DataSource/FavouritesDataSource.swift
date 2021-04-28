//
//  FavouritesDataSource.swift
//  PasswordVault
//
//  Created by Pavel Buzdanov on 26.04.2021.
//

import UIKit
import CoreData


class FavouritesDataSource: NSObject, UITableViewDataSource {
    
    // MARK: - Properties
    private let coreDataService: CoreDataService
    weak var tableView: UITableView?
    
    var data = [SavedData]()
    
    // MARK: - Constructor
    init(coreDataService: CoreDataService) {
        self.coreDataService = coreDataService
        super.init()
        
        self.getData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if data.count == 0 {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "noFavData"), object: nil)
        } else {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "favData"), object: nil)
        }
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavouritesTableViewCell.identifier, for: indexPath) as?
                FavouritesTableViewCell else { return UITableViewCell() }
        let rowData = data[indexPath.row]
        cell.cellData = rowData
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        guard let object = data[indexPath.row] as? NSManagedObject else { return }
        coreDataService.performDelete { (context) in
            context.delete(object)
        }
        self.data.remove(at: indexPath.row)
        self.tableView?.reloadData()
    }
    
    func getData() {
        let context = coreDataService.mainContext
        data = []
        if let account = coreDataService.getObjectWithBool(entity: Accounts.self, compareField: "isFavourite", boolState: true, context: context) {
            self.data.append(contentsOf: account)
        }
        
        if let notes = coreDataService.getObjectWithBool(entity: Notes.self, compareField: "isFavourite", boolState: true, context: context) {
            self.data.append(contentsOf: notes)
        }

        if let cards = coreDataService.getObjectWithBool(entity: Cards.self, compareField: "isFavourite", boolState: true, context: context) {
            self.data.append(contentsOf: cards)
        }

        if let docs = coreDataService.getObjectWithBool(entity: Documents.self, compareField: "isFavourite", boolState: true, context: context) {
            self.data.append(contentsOf: docs)
        }

       
   
        self.tableView?.reloadData()
    }

}
