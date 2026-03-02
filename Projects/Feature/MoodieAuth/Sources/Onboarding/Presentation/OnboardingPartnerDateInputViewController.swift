//
//  OnboardingPartnerDateInputViewController.swift
//  MoodieAuth
//
//  Created by Codex on 2/18/26.
//

import UIKit
import CoreUIKit
import SnapKit
import Then
import Combine
import CombineCocoa

extension OnboardingPartnerDateInputView {
    private enum Constants {
        static let descriptionTypography = Typography(
            fontType: .nanumSquareRound,
            size: .size24,
            weight: .heavy,
            color: .gray1,
            applyLineHeight: true
        )

        static let dDayTypography = Typography(
            fontType: .nanumSquareRound,
            size: .size15,
            weight: .bold,
            color: .gray4,
            applyLineHeight: true
        )

        static let defaultDdayText = "오늘까지 D+N일이에요"
    }
}

final class OnboardingPartnerDateInputView: BaseView {
    var onTouchNextButton: AnyPublisher<Void, Never> {
        nextButton.onTouchButtonPulbisher
    }

    var selectedDatePublisher: AnyPublisher<Date, Never> {
        selectedDateSubject.eraseToAnyPublisher()
    }

    private let descriptionLabel = UILabel(typography: Constants.descriptionTypography).then {
        $0.text = "상대방과 언제부터\n만났나요"
        $0.numberOfLines = 0
    }

    private let dateInputField = MoodieTextField(
        placeholder: "날짜를 선택해요",
        text: nil
    )

    private let dDayLabel = UILabel(typography: Constants.dDayTypography).then {
        $0.text = Constants.defaultDdayText
    }

    private let nextButton = MoodieButton(buttonType: .inactive).then {
        $0.title = "다음"
    }

    private lazy var datePicker = UIDatePicker().then {
        $0.datePickerMode = .date
        $0.locale = Locale(identifier: "ko_KR")
        $0.maximumDate = Date()
        if #available(iOS 13.4, *) {
            $0.preferredDatePickerStyle = .wheels
        }
    }

    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 M월 d일"
        return formatter
    }()

    private let selectedDateSubject = PassthroughSubject<Date, Never>()
    private var currentSelectedDate: Date?
    private var cancellables = Set<AnyCancellable>()

    override func setup() {
        super.setup()

        backgroundColor = .purple6
        configureDateInput()
        bindDatePicker()
    }

    override func setupSubviews() {
        addSubview(descriptionLabel)
        addSubview(dateInputField)
        addSubview(dDayLabel)
        addSubview(nextButton)
    }

    override func setupConstraints() {
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(8)
            make.leading.equalToSuperview().inset(20)
        }

        dateInputField.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(30)
            make.horizontalEdges.equalToSuperview().inset(20)
        }

        dDayLabel.snp.makeConstraints { make in
            make.top.equalTo(dateInputField.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(38)
        }

        nextButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalTo(self.safeAreaLayoutGuide).inset(20)
        }
    }

    func render(viewModel: OnboardingDateInputViewModel) {
        descriptionLabel.text = viewModel.descriptionText

        if currentSelectedDate != viewModel.selectedDate {
            applyDateUI(viewModel.selectedDate)
        }

        if dateInputField.text != viewModel.dateText {
            dateInputField.text = viewModel.dateText
        }

        dDayLabel.text = viewModel.dDayText
        nextButton.buttonType = viewModel.isNextEnabled ? .active : .inactive
    }

    private func configureDateInput() {
        dateInputField.setInputView(datePicker)
        dateInputField.setInputAccessoryView(makeDatePickerToolbar())
        dateInputField.reloadTextInputViews()
    }

    private func bindDatePicker() {
        datePicker
            .controlEventPublisher(for: .valueChanged)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self else { return }
                self.handleUserSelectedDate(self.datePicker.date)
            }
            .store(in: &cancellables)
    }

    private func makeDatePickerToolbar() -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()

        let flexItem = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil
        )
        let doneItem = UIBarButtonItem(
            title: "완료",
            style: .done,
            target: self,
            action: #selector(didTapDoneButton)
        )
        toolbar.items = [flexItem, doneItem]

        return toolbar
    }

    @objc private func didTapDoneButton() {
        handleUserSelectedDate(datePicker.date)
        _ = dateInputField.resignFirstResponder()
    }

    private func handleUserSelectedDate(_ date: Date) {
        let normalizedDate = Calendar.current.startOfDay(for: date)
        applyDateUI(normalizedDate)
        selectedDateSubject.send(normalizedDate)
    }

    private func applyDateUI(_ date: Date?) {
        currentSelectedDate = date

        guard let date else {
            dateInputField.text = nil
            dDayLabel.text = Constants.defaultDdayText
            datePicker.setDate(Date(), animated: false)
            return
        }

        datePicker.setDate(date, animated: false)
        dateInputField.text = dateFormatter.string(from: date)
        dDayLabel.text = "오늘까지 D+\(calculateDday(from: date))일이에요"
    }

    private func calculateDday(from date: Date) -> Int {
        let calendar = Calendar.current
        let fromDate = calendar.startOfDay(for: date)
        let today = calendar.startOfDay(for: Date())
        let elapsedDay = calendar.dateComponents([.day], from: fromDate, to: today).day ?? 0
        return max(1, elapsedDay + 1)
    }
}

final class OnboardingPartnerDateInputViewController: ViewController<OnboardingPartnerDateInputView> {
    var didTapNextPublisher: AnyPublisher<Void, Never> {
        contentView.onTouchNextButton
    }

    var selectedDatePublisher: AnyPublisher<Date, Never> {
        contentView.selectedDatePublisher
    }

    func render(viewModel: OnboardingDateInputViewModel) {
        contentView.render(viewModel: viewModel)
    }
}
