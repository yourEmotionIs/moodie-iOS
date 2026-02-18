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

    var nickname: String {
        nicknameInputField.text?
            .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
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
        $0.text = "남자친구의 별명을 지어주세요"
    }
    
    private let imageContainerView = UIView()
    private let charactorImageView = UIImageView().then {
        $0.image = .onboardingBoy2
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
        imageContainerView.addSubview(charactorImageView)
        
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
        charactorImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.verticalEdges.equalToSuperview().inset(54)
        }
        
        nicknameInputField.snp.makeConstraints { make in
            make.top.equalTo(imageContainerView.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        nextButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalTo(self.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(48)
        }
    }

    func updateNextButton(isEnabled: Bool) {
        nextButton.buttonType = isEnabled ? .active : .inactive
    }
}

final class OnboardingPartnerNameInputViewController: ViewController<OnboardingPartnerNameInputView> {
    private var cancellables = Set<AnyCancellable>()

    var navigateToNextPagePublisher: AnyPublisher<Void, Never> {
        contentView.onTouchNextButton
    }

    var nickname: String {
        contentView.nickname
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewActions()
    }

    private func bindViewActions() {
        contentView.nicknameTextPublisher
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines).count >= 2 }
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isEnabled in
                self?.contentView.updateNextButton(isEnabled: isEnabled)
            }
            .store(in: &cancellables)
    }
}
