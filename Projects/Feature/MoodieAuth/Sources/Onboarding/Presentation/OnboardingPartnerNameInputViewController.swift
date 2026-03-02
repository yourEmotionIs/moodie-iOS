//
//  OnboardingPartnerNameInputViewController.swift
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

final class OnboardingPartnerNameInputView: BaseView {
    var onTouchNextButton: AnyPublisher<Void, Never> {
        nextButton.onTouchButtonPulbisher
    }

    var nicknameTextPublisher: AnyPublisher<String, Never> {
        nicknameInputField.textPublisher
            .map { $0 ?? "" }
            .eraseToAnyPublisher()
    }

    private let descriptionLabel = UILabel(
        typography: Typography(
            fontType: .nanumSquareRound,
            size: .size24,
            weight: .heavy,
            color: .gray1,
            applyLineHeight: true
        )
    ).then {
        $0.text = "상대방의 별명을 지어주세요"
    }

    private let imageContainerView = UIView()
    private let characterImageView = UIImageView().then {
        $0.image = .onboardingBoyClear
        $0.contentMode = .scaleAspectFit
    }

    private let nicknameInputField = MoodieTextField(
        placeholder: "상대방의 별명을 입력해요",
        text: ""
    )

    private let nextButton = MoodieButton(buttonType: .inactive).then {
        $0.title = "다음"
    }

    override func setup() {
        super.setup()

        backgroundColor = .purple6
    }

    override func setupSubviews() {
        addSubview(descriptionLabel)
        addSubview(imageContainerView)
        imageContainerView.addSubview(characterImageView)

        addSubview(nicknameInputField)
        addSubview(nextButton)
    }

    override func setupConstraints() {
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(8)
            make.horizontalEdges.equalToSuperview().inset(20)
        }

        imageContainerView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(18)
            make.horizontalEdges.equalToSuperview().inset(20)
        }

        characterImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.verticalEdges.equalToSuperview().inset(54)
            make.horizontalEdges.lessThanOrEqualToSuperview()
        }

        nicknameInputField.snp.makeConstraints { make in
            make.top.equalTo(imageContainerView.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview().inset(20)
        }

        nextButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalTo(self.safeAreaLayoutGuide).inset(20)
        }
    }

    func render(viewModel: OnboardingNameInputViewModel) {
        descriptionLabel.text = viewModel.descriptionText

        let image = partnerImage(for: viewModel.partnerType)
        if characterImageView.image !== image {
            characterImageView.image = image
        }

        if nicknameInputField.text != viewModel.nickname {
            nicknameInputField.text = viewModel.nickname
        }

        nextButton.buttonType = viewModel.isNextEnabled ? .active : .inactive
    }

    private func partnerImage(for partnerType: OnboardingPartnerType?) -> UIImage {
        switch partnerType {
        case .girlfriend:
            return .onboardingGirlClear
        case .boyfriend, .none:
            return .onboardingBoyClear
        }
    }
}

final class OnboardingPartnerNameInputViewController: ViewController<OnboardingPartnerNameInputView> {
    var didTapNextPublisher: AnyPublisher<Void, Never> {
        contentView.onTouchNextButton
    }

    var nicknameTextPublisher: AnyPublisher<String, Never> {
        contentView.nicknameTextPublisher
    }

    func render(viewModel: OnboardingNameInputViewModel) {
        contentView.render(viewModel: viewModel)
    }
}
