//
//  OnboardingDraft.swift
//  MoodieAuth
//
//  Created by Codex on 3/2/26.
//

import Foundation

struct OnboardingDraft: Equatable {
    var partnerType: OnboardingPartnerType?
    var nickname: String
    var metDate: Date?

    static let initial = OnboardingDraft(
        partnerType: nil,
        nickname: "",
        metDate: nil
    )
}
