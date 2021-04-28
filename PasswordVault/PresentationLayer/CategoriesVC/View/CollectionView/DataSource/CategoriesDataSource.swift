//
//  CategoriesDataSource.swift
//  PasswordVault
//
//  Created by Pavel Buzdanov on 19.04.2021.
//

import UIKit
import CoreData

class CategoriesDataSource: NSObject, UICollectionViewDataSource {
    
    // MARK: - Properties
    let fetchResultController: NSFetchedResultsController<Category>
    
    // MARK: - Constructor
    init(fetchResultController: NSFetchedResultsController<Category>) {
        self.fetchResultController = fetchResultController
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard let sectionsCount = fetchResultController.sections?.count else { return 1 }
        return sectionsCount
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        guard let sectionInfo = fetchResultController.sections?[section] else { return 0 }
        return sectionInfo.numberOfObjects
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoriesCollectionViewCell.identifier, for: indexPath) as?
                CategoriesCollectionViewCell else { return UICollectionViewCell() }
        cell.cellData = fetchResultController.object(at: indexPath)
        return cell
    }
    
}
