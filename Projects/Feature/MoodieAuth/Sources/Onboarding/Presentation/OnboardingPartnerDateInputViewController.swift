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
    }
}

final class OnboardingPartnerDateInputView: BaseView {
    var onTouchNextButton: AnyPublisher<Void, Never> {
        nextButton.onTouchButtonPulbisher
    }

    private let descriptionLabel = UILabel(typography: Constants.descriptionTypography).then {
        $0.text = "(상대방의 별명)과 언제부터\n만났나요"
        $0.numberOfLines = 0
    }

    private let dateInputField = MoodieTextField(
        placeholder: "날짜를 선택해요",
        text: nil
    )

    private let dDayLabel = UILabel(typography: Constants.dDayTypography).then {
        $0.text = "오늘까지 D+N일이에요"
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

    private var selectedDate: Date? {
        didSet {
            let isEnabled = selectedDate != nil
            nextButton.buttonType = isEnabled ? .active : .inactive
        }
    }

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

    func updateNickname(_ nickname: String) {
        let trimmedNickname = nickname.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedNickname.isEmpty {
            descriptionLabel.text = "상대방과 언제부터\n만났나요"
            return
        }

        descriptionLabel.text = "\(trimmedNickname)과 언제부터\n만났나요"
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
                self.applySelectedDate(self.datePicker.date)
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
        applySelectedDate(datePicker.date)
        _ = dateInputField.resignFirstResponder()
    }

    private func applySelectedDate(_ date: Date) {
        selectedDate = date
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
    var navigateToNextPagePublisher: AnyPublisher<Void, Never> {
        contentView.onTouchNextButton
    }

    func configureNickname(_ nickname: String) {
        contentView.updateNickname(nickname)
    }
}
