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
    // MARK: Properties
    var onTouchNextButton: AnyPublisher<Void, Never> {
        nextButton.onTouchButtonPulbisher
    }

    var onTouchBoyPublisher: AnyPublisher<Void, Never> {
        boySelectionItemView.onTouchPartnerItemPublisher
    }

    var onTouchGirlPublisher: AnyPublisher<Void, Never> {
        girlSelectionItemView.onTouchPartnerItemPublisher
    }

    // MARK: UI Components
    private let descriptionLabel = UILabel(
        typography: Typography(
            fontType: .nanumSquareRound,
            size: .size24,
            weight: .heavy,
            color: .gray1,
            applyLineHeight: true
        )
    ).then {
        $0.text = "누구와 함께 사용하나요"
    }

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

    // MARK: Life Cycle
    override func setup() {
        super.setup()

        backgroundColor = .purple6
    }

    override func setupSubviews() {
        addSubview(descriptionLabel)
        addSubview(selectionItemContainerView)
        [boySelectionItemView, girlSelectionItemView]
            .forEach { selectionItemContainerView.addArrangedSubview($0) }

        addSubview(nextButton)
    }

    override func setupConstraints() {
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(8)
            make.horizontalEdges.equalToSuperview().inset(20)
        }

        selectionItemContainerView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(18)
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

    func render(viewModel: OnboardingSelectionViewModel) {
        switch viewModel.selectedPartnerType {
        case .boyfriend:
            boySelectionItemView.activeState = .active
            girlSelectionItemView.activeState = .inactive
        case .girlfriend:
            boySelectionItemView.activeState = .inactive
            girlSelectionItemView.activeState = .active
        case .none:
            boySelectionItemView.activeState = .inactive
            girlSelectionItemView.activeState = .inactive
        }

        nextButton.buttonType = viewModel.isNextEnabled ? .active : .inactive
    }
}

final class OnboardingPartnerSelectionViewController: ViewController<OnboardingPartnerSelectionView> {
    var didTapNextPublisher: AnyPublisher<Void, Never> {
        contentView.onTouchNextButton
    }

    var didSelectPartnerTypePublisher: AnyPublisher<OnboardingPartnerType, Never> {
        Publishers.Merge(
            contentView.onTouchBoyPublisher.map { OnboardingPartnerType.boyfriend },
            contentView.onTouchGirlPublisher.map { OnboardingPartnerType.girlfriend }
        )
        .eraseToAnyPublisher()
    }

    func render(viewModel: OnboardingSelectionViewModel) {
        contentView.render(viewModel: viewModel)
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
    // MARK: Properties
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

    // MARK: UI Components
    private let tapGesture = UITapGestureRecognizer()

    private let partnerImageView = UIImageView()
    private let titleLabel = UILabel(typography: Constants.titleTypo)

    // MARK: Life Cycle
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
