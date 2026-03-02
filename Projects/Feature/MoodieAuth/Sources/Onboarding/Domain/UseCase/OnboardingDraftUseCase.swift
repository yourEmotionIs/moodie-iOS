//
//  OnboardingDraftUseCase.swift
//  MoodieAuth
//
//  Created by Codex on 3/2/26.
//

import Foundation
import Combine

protocol OnboardingDraftUseCase {
    var draftPublisher: AnyPublisher<OnboardingDraft, Never> { get }

    func currentDraft() -> OnboardingDraft
    func updatePartnerType(_ partnerType: OnboardingPartnerType?)
    func updateNickname(_ nickname: String)
    func updateMetDate(_ metDate: Date?)
    func clear()
}

final class OnboardingDraftUseCaseImpl: OnboardingDraftUseCase {
    private let repository: OnboardingDraftRepository

    init(repository: OnboardingDraftRepository) {
        self.repository = repository
    }

    var draftPublisher: AnyPublisher<OnboardingDraft, Never> {
        repository.draftPublisher
    }

    func currentDraft() -> OnboardingDraft {
        repository.currentDraft()
    }

    func updatePartnerType(_ partnerType: OnboardingPartnerType?) {
        repository.savePartnerType(partnerType)
    }

    func updateNickname(_ nickname: String) {
        repository.saveNickname(nickname)
    }

    func updateMetDate(_ metDate: Date?) {
        repository.saveMetDate(metDate)
    }

    func clear() {
        repository.reset()
    }
}
