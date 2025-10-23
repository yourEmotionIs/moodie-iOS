//
//  OnboardingPartnerSelectionViewController.swift
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

final class OnboardingPartnerSelectionView: BaseView {
    //MARK: Properties
    var onTouchNextButton: AnyPublisher<Void, Never> {
        nextButton.onTouchButtonPulbisher
    }
    
    var onTouchBoyPublisher: AnyPublisher<Void, Never> {
        boySelectionItemView.onTouchPartnerItemPublisher
    }
    
    var onTouchGirlPublisher: AnyPublisher<Void, Never> {
        girlSelectionItemView.onTouchPartnerItemPublisher
    }
    
    //MARK: UI Components
    private let selectionItemContainerView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = 8
    }
    private let boySelectionItemView = PartnerSelectionView().then {
        $0.configure(
            partnerImage: .onboardingBoy,
            title: "남자친구"
        )
        $0.activeState = .inactive
    }
    private let girlSelectionItemView = PartnerSelectionView().then {
        $0.configure(
            partnerImage: .onboardingGirl,
            title: "여자친구"
        )
        $0.activeState = .inactive
    }
    
    private let nextButton = MoodieButton(buttonType: .inactive).then {
        $0.title = "다음"
    }
    
    //MARK: Life Cycle
    override func setup() {
        super.setup()
        
        self.backgroundColor = .purple6
    }
    
    override func setupSubviews() {
        addSubview(selectionItemContainerView)
        [boySelectionItemView, girlSelectionItemView]
            .forEach { selectionItemContainerView.addArrangedSubview($0) }
        
        addSubview(nextButton)
    }
    
    override func setupConstraints() {
        selectionItemContainerView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(18)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        boySelectionItemView.snp.makeConstraints { make in
            make.height.equalTo(boySelectionItemView.snp.width)
        }
        
        girlSelectionItemView.snp.makeConstraints { make in
            make.height.equalTo(girlSelectionItemView.snp.width)
        }
        
        nextButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalTo(self.safeAreaLayoutGuide).inset(20)
        }
    }
    
    func toggleBoySelection() {
        boySelectionItemView.activeState = boySelectionItemView.activeState == .active ? .inactive : .active
        girlSelectionItemView.activeState = .inactive
    }
    
    func toggleGirlSelection() {
        girlSelectionItemView.activeState = girlSelectionItemView.activeState == .active ? .inactive : .active
        boySelectionItemView.activeState = .inactive
    }
}

final class OnboardingPartnerSelectionViewController: ViewController<OnboardingPartnerSelectionView> {
    private var cancellables = Set<AnyCancellable>()
    
    var navigateToNextPagePublisher: AnyPublisher<Void, Never> {
        contentView.onTouchNextButton
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewActions()
    }
    
    private func bindViewActions() {
        contentView.onTouchBoyPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.contentView.toggleBoySelection()
            }
            .store(in: &cancellables)
        
        contentView.onTouchGirlPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.contentView.toggleGirlSelection()
            }
            .store(in: &cancellables)
    }
}

extension PartnerSelectionView {
    private enum Constants {
        static let titleTypo = Typography(
            fontType: .nanumSquareRound,
            size: .size16,
            weight: .bold,
            alignment: .center,
            color: .gray1,
            applyLineHeight: true
        )
    }
}

extension PartnerSelectionView {
    enum ActiveState {
        case active
        case inactive
    }
}

final class PartnerSelectionView: BaseView {
    //MARK: Properties
    var onTouchPartnerItemPublisher: AnyPublisher<Void, Never> {
        tapGesture.tapPublisher
            .map { _ in () }
            .eraseToAnyPublisher()
    }
    
    var activeState: ActiveState = .inactive {
        didSet {
            switch activeState {
            case .active:
                backgroundColor = .purple5
                layer.borderWidth = 3
                layer.borderColor = UIColor.purple3.cgColor
            case .inactive:
                backgroundColor = .gray8
                layer.borderWidth = 0
                layer.borderColor = UIColor.clear.cgColor
            }
        }
    }
    
    //MARK: UI Components
    private let tapGesture = UITapGestureRecognizer()
    
    private let partnerImageView = UIImageView()
    private let titleLabel = UILabel(typography: Constants.titleTypo)
    
    //MARK: Life Cycle
    override func setup() {
        super.setup()
        
        layer.cornerRadius = 24
        backgroundColor = .gray8
        
        addGestureRecognizer(tapGesture)
    }
    
    override func setupSubviews() {
        addSubview(partnerImageView)
        addSubview(titleLabel)
    }
    
    override func setupConstraints() {
        partnerImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(8)
            make.centerX.equalToSuperview()
            make.size.equalTo(120)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(partnerImageView.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
        }
    }
    
    func configure(
        partnerImage: UIImage,
        title: String
    ) {
        partnerImageView.image = partnerImage
        titleLabel.text = title
    }
}
