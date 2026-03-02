//
//  OnboardingPresenter.swift
//  MoodieAuth
//
//  Created by Codex on 3/2/26.
//

import Foundation

final class OnboardingPresenter {
    private enum Constants {
        static let defaultNameDescription = "상대방의 별명을 지어주세요"
        static let emptyNicknameDateDescription = "상대방과 언제부터\n만났나요"
        static let emptyNicknameInvitationDescription = "상대방에게 무디 초대장을\n보내주세요"
        static let emptyNicknameInvitationSubtitle = "상대방이 초대장을 받으면\n무디를 함께 시작할 수 있어요"
        static let defaultDdayText = "오늘까지 D+N일이에요"
    }

    private let calendar: Calendar
    private let dateFormatter: DateFormatter

    init(calendar: Calendar = .current) {
        self.calendar = calendar

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 M월 d일"
        self.dateFormatter = formatter
    }

    func presentSelectionViewModel(from draft: OnboardingDraft) -> OnboardingSelectionViewModel {
        OnboardingSelectionViewModel(
            selectedPartnerType: draft.partnerType,
            isNextEnabled: draft.partnerType != nil
        )
    }

    func presentNameInputViewModel(from draft: OnboardingDraft) -> OnboardingNameInputViewModel {
        let descriptionText = draft.partnerType?.nicknameDescriptionText
            ?? Constants.defaultNameDescription

        return OnboardingNameInputViewModel(
            descriptionText: descriptionText,
            partnerType: draft.partnerType,
            nickname: draft.nickname,
            isNextEnabled: validateNickname(draft.nickname)
        )
    }

    func presentDateInputViewModel(from draft: OnboardingDraft) -> OnboardingDateInputViewModel {
        let trimmedNickname = draft.nickname.trimmingCharacters(in: .whitespacesAndNewlines)

        let descriptionText: String
        if trimmedNickname.isEmpty {
            descriptionText = Constants.emptyNicknameDateDescription
        } else {
            descriptionText = "\(trimmedNickname)과 언제부터\n만났나요"
        }

        return OnboardingDateInputViewModel(
            descriptionText: descriptionText,
            selectedDate: draft.metDate,
            dateText: draft.metDate.map { dateFormatter.string(from: $0) },
            dDayText: makeDdayText(from: draft.metDate),
            isNextEnabled: draft.metDate != nil
        )
    }

    func presentInvitationViewModel(from draft: OnboardingDraft) -> OnboardingInvitationViewModel {
        let trimmedNickname = draft.nickname.trimmingCharacters(in: .whitespacesAndNewlines)

        if trimmedNickname.isEmpty {
            return OnboardingInvitationViewModel(
                partnerType: draft.partnerType,
                descriptionText: Constants.emptyNicknameInvitationDescription,
                subtitleText: Constants.emptyNicknameInvitationSubtitle
            )
        }

        return OnboardingInvitationViewModel(
            partnerType: draft.partnerType,
            descriptionText: "\(trimmedNickname)에게 무디 초대장을\n보내주세요",
            subtitleText: "\(trimmedNickname)이 초대장을 받으면\n무디를 함께 시작할 수 있어요"
        )
    }

    func validateNickname(_ nickname: String) -> Bool {
        nickname.trimmingCharacters(in: .whitespacesAndNewlines).count >= 2
    }

    private func makeDdayText(from metDate: Date?) -> String {
        guard let metDate else {
            return Constants.defaultDdayText
        }

        let fromDate = calendar.startOfDay(for: metDate)
        let today = calendar.startOfDay(for: Date())
        let elapsedDay = calendar.dateComponents([.day], from: fromDate, to: today).day ?? 0
        let dday = max(1, elapsedDay + 1)

        return "오늘까지 D+\(dday)일이에요"
    }
}
