//
//  OnboardingViewController.swift
//  MoodieAuth
//
//  Created by 이숭인 on 10/22/25.
//

import UIKit
import CoreUIKit
import SnapKit
import Then
import Combine
import CombineCocoa

final class OnboardingView: BaseView {
    let partnerSelectionViewController = OnboardingPartnerSelectionViewController()
    
    let partnerNameInputViewController = OnboardingPartnerNameInputViewController()

    let partnerDateInputViewController = OnboardingPartnerDateInputViewController()
    
    let pageViewController = UIPageViewController(
        transitionStyle: .scroll,
        navigationOrientation: .horizontal
    )
    
    var viewControllers: [UIViewController] {
        return [partnerSelectionViewController, partnerNameInputViewController, partnerDateInputViewController]
    }
    
    override func setup() {
        super.setup()
        
        self.backgroundColor = .gray1
        
        pageViewController.setViewControllers(
            [partnerSelectionViewController],
            direction: .forward,
            animated: false
        )
    }
    
    override func setupSubviews() {
        addSubview(pageViewController.view)
    }
    
    override func setupConstraints() {
        pageViewController.view.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
}

final class OnboardingViewController: ViewController<OnboardingView> {
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        initNavigationBar()
        
        addChild(contentView.pageViewController)
        contentView.pageViewController.didMove(toParent: self)
        
        bindActions()
    }
    private func bindActions() {
        contentView.partnerSelectionViewController
            .navigateToNextPagePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self else { return }
                contentView.pageViewController.setViewControllers(
                    [contentView.partnerNameInputViewController],
                    direction: .forward,
                    animated: true
                )
            }
            .store(in: &cancellables)
        
        contentView.partnerNameInputViewController
            .navigateToNextPagePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self else { return }
                contentView.partnerDateInputViewController
                    .configureNickname(contentView.partnerNameInputViewController.nickname)

                contentView.pageViewController.setViewControllers(
                    [contentView.partnerDateInputViewController],
                    direction: .forward,
                    animated: true
                )
            }
            .store(in: &cancellables)

        contentView.partnerDateInputViewController
            .navigateToNextPagePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self else { return }
                navigationController?.popToRootViewController(animated: true)
            }
            .store(in: &cancellables)
    }
}

extension OnboardingViewController: NavigationBarApplicable {
    var navigationBarType: NavigationBarType {
        .standard(
            title: "",
            titleColor: .white,
            font: UIFont.systemFont(ofSize: 18, weight: .bold),
            backgroundColor: .purple6,
            hasShadow: false
        )
    }
    
    public var leftButtonItems: [NavigationBarButtonType] {
        [
            .backImage(
                identifier: "back_button",
                image: .chevronLeft,
                color: .gray1,
                renderingMode: .alwaysTemplate,
                enableAutoClose: true
            )
        ]
    }
    
    public var rightButtonItems: [NavigationBarButtonType] {
        [ ]
    }
    
    public func handleNavigationButtonAction(with identifier: String) {
        switch identifier {
        case "back_button":
            navigationController?.popViewController(animated: true)
        default:
            break
        }
    }
}
