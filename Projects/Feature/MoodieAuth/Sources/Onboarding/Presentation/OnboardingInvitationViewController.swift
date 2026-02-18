//
//  OnboardingInvitationViewController.swift
//  MoodieAuth
//
//  Created by Codex on 2/18/26.
//

import UIKit
import CoreUIKit
import SnapKit
import Then
import Combine

extension OnboardingInvitationView {
    private enum Constants {
        static let descriptionTypography = Typography(
            fontType: .nanumSquareRound,
            size: .size24,
            weight: .heavy,
            color: .gray1,
            applyLineHeight: true
        )

        static let subtitleTypography = Typography(
            fontType: .nanumSquareRound,
            size: .size15,
            weight: .bold,
            alignment: .center,
            color: .gray4,
            applyLineHeight: true
        )

        static let cardTitleTypography = Typography(
            fontType: .nanumSquareRound,
            size: .size24,
            weight: .heavy,
            alignment: .center,
            color: .gray1,
            applyLineHeight: true
        )

        static let cardMessageTypography = Typography(
            fontType: .nanumSquareRound,
            size: .size22,
            weight: .heavy,
            alignment: .center,
            color: .gray1,
            applyLineHeight: true
        )
    }
}

final class OnboardingInvitationView: BaseView {
    var onTouchInviteButtonPublisher: AnyPublisher<Void, Never> {
        inviteButton.onTouchButtonPulbisher
    }

    private let descriptionLabel = UILabel(typography: Constants.descriptionTypography).then {
        $0.text = "(상대방의 별명)에게 무디 초대장을\n보내주세요"
        $0.numberOfLines = 0
    }

    private let invitationCardView = UIView().then {
        $0.backgroundColor = .purple5
        $0.layer.cornerRadius = 24
        $0.clipsToBounds = true
    }

    private let cardTitleLabel = UILabel(typography: Constants.cardTitleTypography).then {
        $0.text = "Moodie"
    }

    private let cardMessageLabel = UILabel(typography: Constants.cardMessageTypography).then {
        $0.text = "소중한 너와 매일매일\n감정을 공유하고 싶어"
        $0.numberOfLines = 0
    }

    private let cardImageView = UIImageView().then {
        $0.image = .onboardingBoyHalf
        $0.contentMode = .scaleAspectFit
    }

    private let subtitleLabel = UILabel(typography: Constants.subtitleTypography).then {
        $0.text = "(상대방의 별명)이 초대장을 받으면\n무디를 함께 시작할 수 있어요"
        $0.numberOfLines = 0
    }

    private let inviteButton = MoodieButton(buttonType: .active).then {
        $0.title = "초대장 보내기"
    }

    override func setup() {
        super.setup()

        backgroundColor = .purple6
    }

    override func setupSubviews() {
        addSubview(descriptionLabel)
        addSubview(invitationCardView)
        invitationCardView.addSubview(cardTitleLabel)
        invitationCardView.addSubview(cardMessageLabel)
        invitationCardView.addSubview(cardImageView)
        addSubview(subtitleLabel)
        addSubview(inviteButton)
    }

    override func setupConstraints() {
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(8)
            make.horizontalEdges.equalToSuperview().inset(20)
        }

        invitationCardView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(30)
            make.horizontalEdges.equalToSuperview().inset(20)
        }

        cardTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.centerX.equalToSuperview()
        }

        cardMessageLabel.snp.makeConstraints { make in
            make.top.equalTo(cardTitleLabel.snp.bottom).offset(14)
            make.centerX.equalToSuperview()
            make.horizontalEdges.lessThanOrEqualToSuperview().inset(16)
        }

        cardImageView.snp.makeConstraints { make in
            make.top.equalTo(cardMessageLabel.snp.bottom).offset(56)
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
        }

        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(invitationCardView.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview().inset(20)
        }

        inviteButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalTo(self.safeAreaLayoutGuide).inset(20)
        }
    }

    func updateNickname(_ nickname: String) {
        let trimmedNickname = nickname.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedNickname.isEmpty {
            descriptionLabel.text = "상대방에게 무디 초대장을\n보내주세요"
            subtitleLabel.text = "상대방이 초대장을 받으면\n무디를 함께 시작할 수 있어요"
            return
        }

        descriptionLabel.text = "\(trimmedNickname)에게 무디 초대장을\n보내주세요"
        subtitleLabel.text = "\(trimmedNickname)이 초대장을 받으면\n무디를 함께 시작할 수 있어요"
    }
}

final class OnboardingInvitationViewController: ViewController<OnboardingInvitationView> {
    var navigateToNextPagePublisher: AnyPublisher<Void, Never> {
        contentView.onTouchInviteButtonPublisher
    }

    func configureNickname(_ nickname: String) {
        contentView.updateNickname(nickname)
    }
}
