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
    }
}

final class OnboardingInvitationView: BaseView {
    var onTouchInviteButtonPublisher: AnyPublisher<Void, Never> {
        inviteButton.onTouchButtonPulbisher
    }

    private let descriptionLabel = UILabel(typography: Constants.descriptionTypography).then {
        $0.text = "상대방에게 무디 초대장을\n보내주세요"
        $0.numberOfLines = 0
    }

    private let invitationCardImageView = UIImageView().then {
        $0.image = .onboardingBoyCard
        $0.contentMode = .scaleAspectFit
    }

    private let subtitleLabel = UILabel(typography: Constants.subtitleTypography).then {
        $0.text = "상대방이 초대장을 받으면\n무디를 함께 시작할 수 있어요"
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
        addSubview(invitationCardImageView)
        addSubview(subtitleLabel)
        addSubview(inviteButton)
    }

    override func setupConstraints() {
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(8)
            make.horizontalEdges.equalToSuperview().inset(20)
        }

        invitationCardImageView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(30)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(invitationCardImageView.snp.width)
        }

        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(invitationCardImageView.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview().inset(20)
        }

        inviteButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalTo(self.safeAreaLayoutGuide).inset(20)
        }
    }

    func render(viewModel: OnboardingInvitationViewModel) {
        let image = cardImage(for: viewModel.partnerType)
        if invitationCardImageView.image !== image {
            invitationCardImageView.image = image
        }

        descriptionLabel.text = viewModel.descriptionText
        subtitleLabel.text = viewModel.subtitleText
    }

    private func cardImage(for partnerType: OnboardingPartnerType?) -> UIImage {
        switch partnerType {
        case .girlfriend:
            return .onboardingGirlCard
        case .boyfriend, .none:
            return .onboardingBoyCard
        }
    }
}

final class OnboardingInvitationViewController: ViewController<OnboardingInvitationView> {
    var didTapInviteButtonPublisher: AnyPublisher<Void, Never> {
        contentView.onTouchInviteButtonPublisher
    }

    func render(viewModel: OnboardingInvitationViewModel) {
        contentView.render(viewModel: viewModel)
    }
}
