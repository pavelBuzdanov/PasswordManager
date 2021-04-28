//
//  ListDataSource.swift
//  PasswordVault
//
//  Created by Pavel Buzdanov on 25.04.2021.

import UIKit
import CoreData

class ListDataSource<T: NSManagedObject>: NSObject, UITableViewDataSource {
    
    // MARK: - Properties
    let fetchResultController: NSFetchedResultsController<T>
    let coreDataService: CoreDataService
    
    // MARK: - Constructor
    init(fetchResultController: NSFetchedResultsController<T>, coreDataService: CoreDataService) {
        self.fetchResultController = fetchResultController
        self.coreDataService = coreDataService
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let sectionsCount = fetchResultController.sections?.count else { return 1 }
        return sectionsCount
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionInfo = fetchResultController.sections?[section] else { return 0 }
        if sectionInfo.numberOfObjects == 0 {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "noListData"), object: nil)
        } else {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "listData"), object: nil)
        }
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.identifier, for: indexPath) as?
                ListTableViewCell else { return UITableViewCell() }
        cell.cellData = fetchResultController.object(at: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        let object = fetchResultController.object(at: indexPath)
        fetchResultController.managedObjectContext.delete(object)
        coreDataService.performDelete { (context) in
            context.delete(object)
        }
    }
    
}
