//
//  CategotiesCollectionView.swift
//  PasswordVault
//
//  Created by Pavel Buzdanov on 19.04.2021.
//

import UIKit
import CoreData

class CategotiesCollectionView: UICollectionView {
    
    // MARK: - Properties
    var operations: [BlockOperation] = []
    
    var didSelectCategoty: ((_ indexPath: Category) -> Void)?
    
    private let coreDataService: CoreDataService
    
    lazy var categoriesDataSource: CategoriesDataSource = {
        let context = coreDataService.mainContext
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        request.fetchBatchSize = 10
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
        return CategoriesDataSource(fetchResultController: fetchResultController)
    }()
    
    // MARK: - Constructor
    init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout, coreDataService: CoreDataService ) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 7
        layout.minimumLineSpacing = 14
        layout.sectionInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        self.coreDataService = coreDataService
        super.init(frame: frame, collectionViewLayout: layout)
        self.backgroundColor = .clear
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.translatesAutoresizingMaskIntoConstraints = false
        self.register(CategoriesCollectionViewCell.self, forCellWithReuseIdentifier: CategoriesCollectionViewCell.identifier)
        self.dataSource = categoriesDataSource
        self.delegate = self
        saveToDataBase()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func saveToDataBase() {
        if !UserDefaults.standard.bool(forKey: "firstLaunch") {
            let defaultData = CategoryDefaultModel.defaultModel
            defaultData.forEach { (model) in
                self.coreDataService.performSave {(context) in
                    _ = Category(title: model.title, image: model.image, context: context)
                }
            }
            UserDefaults.standard.setValue(true, forKey: "firstLaunch")
        }
    }
    
    deinit {
        for operation in operations {
            operation.cancel()
        }
         operations.removeAll()
    }
}

// MARK: - UICollectionViewDelegate
extension CategotiesCollectionView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath)  else { return }
        Animator.scaleAnimation(view: cell, duration: 0.5, scaleX: 0.96, scaleY: 0.96).handler()
        let category = categoriesDataSource.fetchResultController.object(at: indexPath)
        self.didSelectCategoty?(category)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let layout = collectionViewLayout as? UICollectionViewFlowLayout else { return CGSize(width: 0, height: 0) }
        let width = collectionView.bounds.size.width / 2 - (layout.minimumInteritemSpacing + layout.sectionInset.left)
        return CGSize(width: width, height: 115)
    }
    
}

// MARK: - NSFetchedResultsControllerDelegate
extension CategotiesCollectionView: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {}
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        performBatchUpdates({ () -> Void in
            for op: BlockOperation in self.operations { op.start() }
        }, completion: { (finished) -> Void in
            self.operations.removeAll()
            
        })
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any, at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            operations.append(BlockOperation(block: { [weak self] in
                self?.insertItems(at: [newIndexPath])
            }))
        case .move:
            guard let newIndexPath = newIndexPath else { return }
            guard let indexPath = indexPath else { return }
            operations.append(BlockOperation(block: { [weak self] in
                self?.moveItem(at: indexPath, to: newIndexPath)
            }))
        case .update:
            guard let indexPath = indexPath else { return }
            operations.append(BlockOperation(block: { [weak self] in
                self?.reloadItems(at: [indexPath])
            }))
        case .delete:
            operations.append(BlockOperation(block: { [weak self] in
                self?.deleteItems(at: [indexPath!])
            }))
        @unknown default:
            fatalError("NSFetchedResultsController changing Error")
        }
    }
}

