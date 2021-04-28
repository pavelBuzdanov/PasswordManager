//
//  OnboardingCollectionView.swift
//  PasswordVault
//
//  Created by Pavel Buzdanov on 27.04.2021.
//

import UIKit

class OnboardingCollectionView: UICollectionView {
    
    // MARK: - Properties
    private let data = OnboardingModel.defaultModel
    
    // MARK: - Actions
    var collectionViewWillDispayCellAt: ((IndexPath) -> ())?
    
    // MARK: - Constructor
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        super.init(frame: frame, collectionViewLayout: layout)
        self.backgroundColor = .clear
        self.isPagingEnabled = true
        self.showsHorizontalScrollIndicator = false
        self.translatesAutoresizingMaskIntoConstraints = false
        self.register(OnboardingCollectionViewCell.self, forCellWithReuseIdentifier: OnboardingCollectionViewCell.identifier)
        delegate = self
        dataSource = self
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - UICollectionViewDelegate
extension OnboardingCollectionView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.collectionViewWillDispayCellAt?(indexPath)
    }
    
}

// MARK: - UICollectionViewDataSource
extension OnboardingCollectionView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingCollectionViewCell.identifier, for: indexPath) as? OnboardingCollectionViewCell else { return UICollectionViewCell() }
        
        let cellData = data[indexPath.row]
        cell.cellData = cellData
        
        return cell
    }
    
}
