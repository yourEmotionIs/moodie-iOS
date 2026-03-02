//
//  OnboardingDraftInMemoryRepository.swift
//  MoodieAuth
//
//  Created by Codex on 3/2/26.
//

import Foundation
import Combine

final class OnboardingDraftInMemoryRepository: OnboardingDraftRepository {
    private let subject = CurrentValueSubject<OnboardingDraft, Never>(.initial)

    var draftPublisher: AnyPublisher<OnboardingDraft, Never> {
        subject.eraseToAnyPublisher()
    }

    func currentDraft() -> OnboardingDraft {
        subject.value
    }

    func savePartnerType(_ partnerType: OnboardingPartnerType?) {
        var draft = subject.value
        draft.partnerType = partnerType
        subject.send(draft)
    }

    func saveNickname(_ nickname: String) {
        var draft = subject.value
        draft.nickname = nickname
        subject.send(draft)
    }

    func saveMetDate(_ metDate: Date?) {
        var draft = subject.value
        draft.metDate = metDate
        subject.send(draft)
    }

    func reset() {
        subject.send(.initial)
    }
}
