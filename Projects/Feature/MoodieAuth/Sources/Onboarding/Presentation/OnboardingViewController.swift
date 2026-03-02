//
//  OnboardingViewController.swift
//  MoodieAuth
//
//  Created by 이숭인 on 10/22/25.
//

import UIKit
import CoreUIKit
import SnapKit
import Then
import Combine
import CombineCocoa

final class OnboardingView: BaseView {
    let partnerSelectionViewController = OnboardingPartnerSelectionViewController()
    let partnerNameInputViewController = OnboardingPartnerNameInputViewController()
    let partnerDateInputViewController = OnboardingPartnerDateInputViewController()
    let invitationViewController = OnboardingInvitationViewController()

    let pageViewController = UIPageViewController(
        transitionStyle: .scroll,
        navigationOrientation: .horizontal
    )

    override func setup() {
        super.setup()

        backgroundColor = .gray1

        pageViewController.setViewControllers(
            [partnerSelectionViewController],
            direction: .forward,
            animated: false
        )
    }

    override func setupSubviews() {
        addSubview(pageViewController.view)
    }

    override func setupConstraints() {
        pageViewController.view.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
}

final class OnboardingViewController: ViewController<OnboardingView> {
    private var cancellables = Set<AnyCancellable>()
    private let interactor: OnboardingInteractor

    init(interactor: OnboardingInteractor = OnboardingViewController.makeInteractor()) {
        self.interactor = interactor
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        initNavigationBar()

        addChild(contentView.pageViewController)
        contentView.pageViewController.didMove(toParent: self)

        bindViewActions()
        bindInteractorOutputs()

        interactor.viewDidLoad()
    }

    private static func makeInteractor() -> OnboardingInteractor {
        let repository = OnboardingDraftInMemoryRepository()
        let useCase = OnboardingDraftUseCaseImpl(repository: repository)
        let presenter = OnboardingPresenter()

        return OnboardingInteractor(
            useCase: useCase,
            presenter: presenter
        )
    }

    private func bindViewActions() {
        contentView.partnerSelectionViewController.didSelectPartnerTypePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] partnerType in
                self?.interactor.didSelectPartnerType(partnerType)
            }
            .store(in: &cancellables)

        contentView.partnerSelectionViewController.didTapNextPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.interactor.didTapNext()
            }
            .store(in: &cancellables)

        contentView.partnerNameInputViewController.nicknameTextPublisher
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] nickname in
                self?.interactor.didUpdateNickname(nickname)
            }
            .store(in: &cancellables)

        contentView.partnerNameInputViewController.didTapNextPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.interactor.didTapNext()
            }
            .store(in: &cancellables)

        contentView.partnerDateInputViewController.selectedDatePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] date in
                self?.interactor.didSelectMetDate(date)
            }
            .store(in: &cancellables)

        contentView.partnerDateInputViewController.didTapNextPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.interactor.didTapNext()
            }
            .store(in: &cancellables)

        contentView.invitationViewController.didTapInviteButtonPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.interactor.didTapNext()
            }
            .store(in: &cancellables)
    }

    private func bindInteractorOutputs() {
        interactor.selectionViewModelPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] viewModel in
                self?.contentView.partnerSelectionViewController.render(viewModel: viewModel)
            }
            .store(in: &cancellables)

        interactor.nameInputViewModelPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] viewModel in
                self?.contentView.partnerNameInputViewController.render(viewModel: viewModel)
            }
            .store(in: &cancellables)

        interactor.dateInputViewModelPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] viewModel in
                self?.contentView.partnerDateInputViewController.render(viewModel: viewModel)
            }
            .store(in: &cancellables)

        interactor.invitationViewModelPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] viewModel in
                self?.contentView.invitationViewController.render(viewModel: viewModel)
            }
            .store(in: &cancellables)

        interactor.navigationCommandPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] navigationCommand in
                self?.handleNavigationCommand(navigationCommand)
            }
            .store(in: &cancellables)
    }

    private func handleNavigationCommand(_ navigationCommand: OnboardingNavigationCommand) {
        switch navigationCommand {
        case let .moveTo(step, direction, animated):
            contentView.pageViewController.setViewControllers(
                [viewController(for: step)],
                direction: pageNavigationDirection(from: direction),
                animated: animated
            )

        case .exit:
            navigationController?.popViewController(animated: true)
        }
    }

    private func viewController(for step: OnboardingStep) -> UIViewController {
        switch step {
        case .partnerSelection:
            return contentView.partnerSelectionViewController
        case .partnerNameInput:
            return contentView.partnerNameInputViewController
        case .partnerDateInput:
            return contentView.partnerDateInputViewController
        case .invitation:
            return contentView.invitationViewController
        }
    }

    private func pageNavigationDirection(
        from direction: OnboardingNavigationDirection
    ) -> UIPageViewController.NavigationDirection {
        switch direction {
        case .forward:
            return .forward
        case .reverse:
            return .reverse
        }
    }
}

extension OnboardingViewController: NavigationBarApplicable {
    var navigationBarType: NavigationBarType {
        .standard(
            title: "",
            titleColor: .white,
            font: UIFont.systemFont(ofSize: 18, weight: .bold),
            backgroundColor: .purple6,
            hasShadow: false
        )
    }

    public var leftButtonItems: [NavigationBarButtonType] {
        [
            .backImage(
                identifier: "back_button",
                image: .chevronLeft,
                color: .gray1,
                renderingMode: .alwaysTemplate,
                enableAutoClose: false
            )
        ]
    }

    public var rightButtonItems: [NavigationBarButtonType] {
        []
    }

    public func handleNavigationButtonAction(with identifier: String) {
        switch identifier {
        case "back_button":
            interactor.didTapBack()
        default:
            break
        }
    }
}
