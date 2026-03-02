//
//  OnboardingInteractor.swift
//  MoodieAuth
//
//  Created by Codex on 3/2/26.
//

import Foundation
import Combine

final class OnboardingInteractor {
    private let useCase: OnboardingDraftUseCase
    private let presenter: OnboardingPresenter
    private let calendar: Calendar

    private let stepSubject = CurrentValueSubject<OnboardingStep, Never>(.partnerSelection)
    private let navigationCommandSubject = PassthroughSubject<OnboardingNavigationCommand, Never>()

    init(
        useCase: OnboardingDraftUseCase,
        presenter: OnboardingPresenter,
        calendar: Calendar = .current
    ) {
        self.useCase = useCase
        self.presenter = presenter
        self.calendar = calendar
    }

    var selectionViewModelPublisher: AnyPublisher<OnboardingSelectionViewModel, Never> {
        useCase.draftPublisher
            .map { [presenter] draft in
                presenter.presentSelectionViewModel(from: draft)
            }
            .removeDuplicates()
            .eraseToAnyPublisher()
    }

    var nameInputViewModelPublisher: AnyPublisher<OnboardingNameInputViewModel, Never> {
        useCase.draftPublisher
            .map { [presenter] draft in
                presenter.presentNameInputViewModel(from: draft)
            }
            .removeDuplicates()
            .eraseToAnyPublisher()
    }

    var dateInputViewModelPublisher: AnyPublisher<OnboardingDateInputViewModel, Never> {
        useCase.draftPublisher
            .map { [presenter] draft in
                presenter.presentDateInputViewModel(from: draft)
            }
            .removeDuplicates()
            .eraseToAnyPublisher()
    }

    var invitationViewModelPublisher: AnyPublisher<OnboardingInvitationViewModel, Never> {
        useCase.draftPublisher
            .map { [presenter] draft in
                presenter.presentInvitationViewModel(from: draft)
            }
            .removeDuplicates()
            .eraseToAnyPublisher()
    }

    var navigationCommandPublisher: AnyPublisher<OnboardingNavigationCommand, Never> {
        navigationCommandSubject.eraseToAnyPublisher()
    }

    func viewDidLoad() {
        stepSubject.send(.partnerSelection)
        navigationCommandSubject.send(
            .moveTo(step: .partnerSelection, direction: .forward, animated: false)
        )
    }

    func didSelectPartnerType(_ partnerType: OnboardingPartnerType) {
        let currentType = useCase.currentDraft().partnerType
        let nextType: OnboardingPartnerType? = currentType == partnerType ? nil : partnerType
        useCase.updatePartnerType(nextType)
    }

    func didUpdateNickname(_ nickname: String) {
        useCase.updateNickname(nickname)
    }

    func didSelectMetDate(_ metDate: Date) {
        useCase.updateMetDate(calendar.startOfDay(for: metDate))
    }

    func didTapNext() {
        let currentStep = stepSubject.value
        let draft = useCase.currentDraft()

        switch currentStep {
        case .partnerSelection:
            guard draft.partnerType != nil, let nextStep = currentStep.next else {
                return
            }
            moveTo(step: nextStep, direction: .forward)

        case .partnerNameInput:
            guard presenter.validateNickname(draft.nickname), let nextStep = currentStep.next else {
                return
            }
            moveTo(step: nextStep, direction: .forward)

        case .partnerDateInput:
            guard draft.metDate != nil, let nextStep = currentStep.next else {
                return
            }
            moveTo(step: nextStep, direction: .forward)

        case .invitation:
            navigationCommandSubject.send(.exit)
        }
    }

    func didTapBack() {
        let currentStep = stepSubject.value

        guard let previousStep = currentStep.previous else {
            navigationCommandSubject.send(.exit)
            return
        }

        moveTo(step: previousStep, direction: .reverse)
    }

    private func moveTo(
        step: OnboardingStep,
        direction: OnboardingNavigationDirection,
        animated: Bool = true
    ) {
        stepSubject.send(step)
        navigationCommandSubject.send(
            .moveTo(step: step, direction: direction, animated: animated)
        )
    }
}
