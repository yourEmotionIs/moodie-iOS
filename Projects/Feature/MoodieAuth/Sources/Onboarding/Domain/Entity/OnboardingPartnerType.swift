//
//  OnboardingPartnerType.swift
//  MoodieAuth
//
//  Created by Codex on 3/2/26.
//

import Foundation

enum OnboardingPartnerType: Equatable {
    case boyfriend
    case girlfriend
}

extension OnboardingPartnerType {
    var nicknameDescriptionText: String {
        switch self {
        case .boyfriend:
            return "남자친구의 별명을 지어주세요"
        case .girlfriend:
            return "여자친구의 별명을 지어주세요"
        }
    }
}
