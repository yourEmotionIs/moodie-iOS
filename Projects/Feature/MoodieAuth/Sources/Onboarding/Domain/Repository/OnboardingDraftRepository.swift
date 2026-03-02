//
//  OnboardingDraftRepository.swift
//  MoodieAuth
//
//  Created by Codex on 3/2/26.
//

import Foundation
import Combine

protocol OnboardingDraftRepository {
    var draftPublisher: AnyPublisher<OnboardingDraft, Never> { get }

    func currentDraft() -> OnboardingDraft
    func savePartnerType(_ partnerType: OnboardingPartnerType?)
    func saveNickname(_ nickname: String)
    func saveMetDate(_ metDate: Date?)
    func reset()
}
