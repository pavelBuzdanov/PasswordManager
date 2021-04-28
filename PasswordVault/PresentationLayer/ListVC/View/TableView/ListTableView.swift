//
//  ListTableView.swift
//  PasswordVault
//
//  Created by Pavel Buzdanov on 25.04.2021.
//

import UIKit
import CoreData

class ListTableView<T: NSManagedObject>: UITableView, NSFetchedResultsControllerDelegate, UITableViewDelegate  {
    
    // MARK: - Properties
    var category: Category?
    let coreDataService: CoreDataService
    
    var didSelectAccount: ((Accounts) -> ())?
    var didSelectNotes: ((Notes) -> ())?
    var didSelectDocuments: ((Documents) -> ())?
    var didSelectCards: ((Cards) -> ())?
    
    private lazy var listDataSource: ListDataSource<T> = {
        let context = coreDataService.mainContext
        print(context)
        let request: NSFetchRequest<T> = NSFetchRequest(entityName: "\(T.self)")
        let sortDescriptor = NSSortDescriptor(key: "isFavourite", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        
        if let title = self.category?.title {
            if T.self == Accounts.self {
                request.predicate = NSPredicate(format: "%K = %@", #keyPath(Accounts.category.title), title)
            } else if T.self == Documents.self {
                request.predicate = NSPredicate(format: "%K = %@", #keyPath(Documents.category.title), title)
            } else if T.self == Notes.self {
                request.predicate = NSPredicate(format: "%K = %@", #keyPath(Notes.category.title), title)
            } else if T.self == Cards.self {
                request.predicate = NSPredicate(format: "%K = %@", #keyPath(Cards.category.title), title)
            }
        }
       
        let fetchResultController = NSFetchedResultsController(fetchRequest: request,
                                                               managedObjectContext: context,
                                                               sectionNameKeyPath: nil,
                                                               cacheName: nil)
        fetchResultController.delegate = self
        do {
            try fetchResultController.performFetch()
        } catch {
            print("FetchResultController Fetch Error: \(error) \(error.localizedDescription)")
        }
        return ListDataSource(fetchResultController: fetchResultController, coreDataService: coreDataService)
    }()

    // MARK: - Constructor
    init(frame: CGRect = .zero, style: UITableView.Style = .plain, coreDataService: CoreDataService, category: Category) {
        self.coreDataService = coreDataService
        self.category = category
        super.init(frame: frame, style: style)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = UIColor.TableView.backgroundColor
        self.separatorColor = UIColor.TableView.separatorColor
        self.tableFooterView = UIView()
        self.register(ListTableViewCell.self, forCellReuseIdentifier: ListTableViewCell.identifier)
        delegate = self
        dataSource = listDataSource
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    // MARK: - Table View Delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 77
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let object = listDataSource.fetchResultController.object(at: indexPath)
        
        if object is Accounts {
            guard let object = object as? Accounts else { return }
            self.didSelectAccount?(object)
        } else if object is Notes {
            guard let object = object as? Notes else { return }
            self.didSelectNotes?(object)
        } else if object is Cards {
            guard let object = object as? Cards else { return }
            self.didSelectCards?(object)
        } else if object is Documents {
            guard let object = object as? Documents else { return }
            self.didSelectDocuments?(object)
        }
    }
    
    // MARK: - NSFetchedResultsControllerDelegate
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.beginUpdates()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.endUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any, at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {

        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            self.insertRows(at: [newIndexPath], with: .fade)
        case .move:
            guard let newIndexPath = newIndexPath else { return }
            guard let indexPath = indexPath else { return }
            self.deleteRows(at: [indexPath], with: .fade)
            self.insertRows(at: [newIndexPath], with: .fade)
        case .update:
            guard let indexPath = indexPath else { return }
            self.reloadRows(at: [indexPath], with: .fade)
        case .delete:
            guard let indexPath = indexPath else { return }
            self.deleteRows(at: [indexPath], with: .fade)
        @unknown default:
            fatalError("NSFetchedResultsController changing Error")
        }
    }

}

