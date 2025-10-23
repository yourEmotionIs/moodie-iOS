//
//  MoodieLoginViewController.swift
//  MoodieAuth
//
//  Created by 이숭인 on 7/23/25.
//

import UIKit
import CoreUIKit
import CoreAuthKit
import Combine
import CombineCocoa

extension MoodieLoginViewController {
    private enum Constants {
        static let introduceCardGroupWidthRatio: CGFloat = 0.84
        static let introduceCardGroupSpace: CGFloat = 8
    }
}

final class MoodieLoginViewController: ViewController<MoodieLoginView> {
    private var cancellables = Set<AnyCancellable>()
    private let currentPagePublisher = PassthroughSubject<Int, Never>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    private func setup() {
        setupCollectionView()
        bindActions()
    }
    
    private func bindActions() {
        currentPagePublisher
            .receive(on: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] currentPage in
                self?.contentView.updatePageState(with: currentPage)
            }
            .store(in: &cancellables)
        
        contentView.onTouchKakaoLogin
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.navigateToOnboardingView()
            }
            .store(in: &cancellables)
        
        contentView.onTouchAppleLogin
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.navigateToOnboardingView()
            }
            .store(in: &cancellables)
    }
    
    private func setupCollectionView() {
        contentView.collectionView.dataSource = self
        
        contentView.collectionView.register(
            TextCollectionView.self,
            forCellWithReuseIdentifier: TextCollectionView.reuseIdentifier
        )
        
        /// Setup collectionView layout
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(Constants.introduceCardGroupWidthRatio),
            heightDimension: .fractionalHeight(1)
        )
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        section.interGroupSpacing = Constants.introduceCardGroupSpace
        section.visibleItemsInvalidationHandler = { [weak self] (visibleItems, contentOffset, environment) in
            let cellWidth: CGFloat = UIScreen.main.bounds.width * Constants.introduceCardGroupWidthRatio
            let spacing: CGFloat = Constants.introduceCardGroupSpace
            let pageWidth = cellWidth + spacing
            let currentPage = Int(round(contentOffset.x / pageWidth))
            
            self?.currentPagePublisher.send(currentPage)
        }
        
        contentView.collectionView.setCollectionViewLayout(
            UICollectionViewCompositionalLayout(section: section),
            animated: true
        )
    }
    
    private func navigateToOnboardingView() {
        let onboardingViewController = OnboardingViewController()
        
        navigationController?.pushViewController(onboardingViewController, animated: true)
    }
}

extension MoodieLoginViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TextCollectionView.reuseIdentifier, for: indexPath) as? TextCollectionView else {
            return UICollectionViewCell()
        }
        
        return cell
     }
}

final class TextCollectionView: UICollectionViewCell {
    static let reuseIdentifier = String(describing: TextCollectionView.self)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .systemCyan
        contentView.layer.cornerRadius = 24
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

