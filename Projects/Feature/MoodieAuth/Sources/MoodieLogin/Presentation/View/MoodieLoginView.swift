//
//  MoodieLoginView.swift
//  MoodieAuth
//
//  Created by 이숭인 on 10/19/25.
//

import UIKit
import CoreUIKit
import Combine
import CombineCocoa

final class MoodieLoginView: BaseView {
    //MARK: Properties
    var onTouchKakaoLogin: AnyPublisher<Void, Never> {
        kakaoLoginButton.tapPublisher
    }
    
    var onTouchAppleLogin: AnyPublisher<Void, Never> {
        appleLoginButton.tapPublisher
    }
    
    //MARK: - UI Components
    private let serviceLogoLabel = UILabel(
        typography: Typography(
            fontType: .nanumSquareRound,
            size: .size24,
            weight: .heavy,
            color: .gray1
        )
    ).then {
        $0.text = "Moodie"
    }
    
    let collectionViewLayout = {
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.84),
            heightDimension: .fractionalHeight(1)
        )
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        section.interGroupSpacing = 8
        
        return UICollectionViewCompositionalLayout(section: section)
    }()
    
    lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: collectionViewLayout
    ).then {
        $0.alwaysBounceVertical = false
    }
    
    private let pageControl = UIPageControl().then{
        $0.numberOfPages = 4
        $0.currentPage = 0
        $0.currentPageIndicatorTintColor = .purple2
        $0.pageIndicatorTintColor = .purple5
    }
    
    private let loginViewContainer = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fill
        $0.spacing = 8
    }
    private let kakaoLoginButton = UIButton().then {
        $0.setImage(.kakaoLoginLarge, for: .normal)
        $0.layer.cornerRadius = 4
    }
    
    private let appleLoginButton = UIButton().then {
        $0.setImage(.appleLoginLarge, for: .normal)
        $0.layer.cornerRadius = 4
    }
    
    //MARK: - Life cycle
    override func setup() {
        super.setup()
        
        self.backgroundColor = .white
    }
    
    override func setupSubviews() {
        [
            serviceLogoLabel,
            collectionView,
            pageControl,
            loginViewContainer
        ].forEach { addSubview($0) }
        
        [
            kakaoLoginButton,
            appleLoginButton
        ].forEach { loginViewContainer.addArrangedSubview($0) }
    }
    
    override func setupConstraints() {
        serviceLogoLabel.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(serviceLogoLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.548)
        }
        
        pageControl.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(9)
            make.bottom.lessThanOrEqualToSuperview().inset(16)
        }
        
        loginViewContainer.snp.makeConstraints { make in
            make.top.equalTo(pageControl.snp.bottom).offset(38)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.lessThanOrEqualToSuperview()
        }
        
        kakaoLoginButton.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
        
        appleLoginButton.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
    }
    
    func updatePageState(with currentPage: Int) {
        pageControl.currentPage = currentPage
    }
}
