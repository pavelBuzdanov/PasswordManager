//
//  OnboardingViewController.swift
//  PasswordVault
//
//  Created by Pavel Buzdanov on 27.04.2021.
//

import UIKit

class OnboardingViewController: UIViewController {

    // MARK: - Properties
    // MARK: - Views
    let collectionView = OnboardingCollectionView()
    
    private let nextButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Next", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.1843137255, green: 0.5019607843, blue: 0.9294117647, alpha: 1), for: .normal)
        button.titleLabel?.font = Fonts.nunitoExtraBold.of(size: 16)
        return button
    }()
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        nextButton.layer.cornerRadius = 8
        let gradLayer = nextButton.gradient(colors: [#colorLiteral(red: 0.137254902, green: 0.1450980392, blue: 0.1568627451, alpha: 1), #colorLiteral(red: 0.1058823529, green: 0.1137254902, blue: 0.1254901961, alpha: 1)], startPoint: CGPoint(x: 0, y: 0),
                                           endPoint: CGPoint(x: 1, y: 1), opacity: 1.0, location: nil)
        gradLayer.cornerRadius = 8
        nextButton.layer.shadowPath = UIBezierPath(roundedRect: nextButton.bounds, cornerRadius: 8).cgPath
        nextButton.layer.shadowColor = #colorLiteral(red: 0.2274509804, green: 0.2274509804, blue: 0.2274509804, alpha: 0.25)
        nextButton.layer.shadowRadius = 5
        nextButton.layer.shadowOffset = .zero
        nextButton.layer.shadowOpacity = 1.0
    }
    // MARK: - SetupView
    private func setupView() {
        view.backgroundColor = UIColor.ViewControllerColor.backgroundColor
        layoutView()
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        
        collectionView.collectionViewWillDispayCellAt = { [weak self] (indexPath) in
            guard let self = self else { return }
            if indexPath.row == OnboardingModel.defaultModel.count - 1 {
                self.nextButton.removeTarget(nil, action: nil, for: .allEvents)
                self.nextButton.addTarget(self, action: #selector(self.closeView), for: .touchUpInside)
            } else {
                self.nextButton.removeTarget(nil, action: nil, for: .allEvents)
                self.nextButton.addTarget(self, action: #selector(self.nextButtonTapped), for: .touchUpInside)
            }
        }
    }
    
    // MARK: - Actions
    @objc private func nextButtonTapped() {
        Animator.scaleAnimation(view: nextButton, duration: 0.5, scaleX: 0.96, scaleY: 0.96).handler()
        guard let currentPage = collectionView.indexPathsForVisibleItems.first else { return }
        let nextIndexPath = IndexPath(item: currentPage.row + 1, section: currentPage.section)
        
        collectionView.scrollToItem(at: nextIndexPath, at: .centeredHorizontally, animated: true)
    }
    
    @objc private func closeView() {
        UserDefaults.standard.setValue(true, forKey: AppConstants.onboardingState)
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - LayoutView
    private func layoutView() {
        view.addSubview(collectionView)
        view.addSubview(nextButton)
        
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        nextButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(50)
        }
    }


}
