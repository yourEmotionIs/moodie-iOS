//
//  OnboardingViewModel.swift
//  MoodieAuth
//
//  Created by Codex on 3/2/26.
//

import Foundation

enum OnboardingStep: Int, CaseIterable {
    case partnerSelection
    case partnerNameInput
    case partnerDateInput
    case invitation

    var next: OnboardingStep? {
        guard let nextStep = OnboardingStep(rawValue: rawValue + 1) else {
            return nil
        }

        return nextStep
    }

    var previous: OnboardingStep? {
        guard let previousStep = OnboardingStep(rawValue: rawValue - 1) else {
            return nil
        }

        return previousStep
    }
}

enum OnboardingNavigationDirection: Equatable {
    case forward
    case reverse
}

enum OnboardingNavigationCommand: Equatable {
    case moveTo(step: OnboardingStep, direction: OnboardingNavigationDirection, animated: Bool)
    case exit
}

struct OnboardingSelectionViewModel: Equatable {
    let selectedPartnerType: OnboardingPartnerType?
    let isNextEnabled: Bool
}

struct OnboardingNameInputViewModel: Equatable {
    let descriptionText: String
    let partnerType: OnboardingPartnerType?
    let nickname: String
    let isNextEnabled: Bool
}

struct OnboardingDateInputViewModel: Equatable {
    let descriptionText: String
    let selectedDate: Date?
    let dateText: String?
    let dDayText: String
    let isNextEnabled: Bool
}

struct OnboardingInvitationViewModel: Equatable {
    let partnerType: OnboardingPartnerType?
    let descriptionText: String
    let subtitleText: String
}
