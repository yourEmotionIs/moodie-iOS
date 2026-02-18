//
//  MoodieTextField.swift
//  CoreUIKit
//
//  Created by Codex on 2/18/26.
//

import UIKit
import SnapKit
import Then
import Combine
import CombineCocoa

public enum MoodieTextFieldState {
    case active
    case inactive
}

extension MoodieTextFieldState {
    fileprivate var borderColor: UIColor {
        switch self {
        case .active:
            return .purple3
        case .inactive:
            return .purple5
        }
    }
}

extension MoodieTextField {
    private enum Constants {
        static let height: CGFloat = 56
        static let cornerRadius: CGFloat = 16
        static let borderWidth: CGFloat = 3
        static let contentInset = UIEdgeInsets(top: 0, left: 18, bottom: 0, right: 14)

        static let textTypography = Typography(
            fontType: .nanumSquareRound,
            size: .size17,
            weight: .bold,
            alignment: .left,
            color: .gray1,
            applyLineHeight: true
        )

        static let placeholderTypography = Typography(
            fontType: .nanumSquareRound,
            size: .size17,
            weight: .bold,
            alignment: .left,
            color: .gray6,
            applyLineHeight: true
        )
    }
}

public final class MoodieTextField: BaseView {
    public var textPublisher: AnyPublisher<String?, Never> {
        textField.textPublisher
            .eraseToAnyPublisher()
    }

    public var didBeginEditingPublisher: AnyPublisher<Void, Never> {
        textField.controlEventPublisher(for: .editingDidBegin)
            .eraseToAnyPublisher()
    }

    public var didEndEditingPublisher: AnyPublisher<Void, Never> {
        textField.controlEventPublisher(for: .editingDidEnd)
            .eraseToAnyPublisher()
    }

    public var focusPublisher: AnyPublisher<Bool, Never> {
        Publishers.Merge(
            didBeginEditingPublisher.map { true },
            didEndEditingPublisher.map { false }
        )
        .eraseToAnyPublisher()
    }

    public var placeholder: String? {
        didSet {
            applyPlaceholderStyle()
        }
    }

    public var text: String? {
        get {
            textField.text
        } set {
            textField.text = newValue
        }
    }

    public weak var delegate: UITextFieldDelegate? {
        get {
            textField.delegate
        } set {
            textField.delegate = newValue
        }
    }

    public private(set) var state: MoodieTextFieldState = .inactive {
        didSet {
            applyStateStyle()
        }
    }

    private let textField = UITextField(typography: Constants.textTypography).then {
        $0.borderStyle = .none
        $0.backgroundColor = .clear
        $0.textColor = .gray1
        $0.tintColor = .gray1
    }

    private var cancellables = Set<AnyCancellable>()

    public init(
        placeholder: String? = nil,
        text: String? = nil
    ) {
        self.placeholder = placeholder

        super.init(frame: .zero)

        self.text = text
        applyPlaceholderStyle()
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @discardableResult
    public override func becomeFirstResponder() -> Bool {
        textField.becomeFirstResponder()
    }

    @discardableResult
    public override func resignFirstResponder() -> Bool {
        textField.resignFirstResponder()
    }

    public override var isFirstResponder: Bool {
        textField.isFirstResponder
    }

    public func setInputView(_ view: UIView?) {
        textField.inputView = view
    }

    public func setInputAccessoryView(_ view: UIView?) {
        textField.inputAccessoryView = view
    }

    public func reloadTextInputViews() {
        textField.reloadInputViews()
    }

    public override func setup() {
        super.setup()

        backgroundColor = .gray8
        layer.cornerRadius = Constants.cornerRadius
        layer.borderWidth = Constants.borderWidth

        applyStateStyle()
        bindFocusEvents()
    }

    public override func setupSubviews() {
        addSubview(textField)
    }

    public override func setupConstraints() {
        self.snp.makeConstraints { make in
            make.height.equalTo(Constants.height)
        }

        textField.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(Constants.contentInset.left)
            make.trailing.equalToSuperview().inset(Constants.contentInset.right)
            make.centerY.equalToSuperview()
        }
    }

    private func bindFocusEvents() {
        focusPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isFocused in
                self?.state = isFocused ? .active : .inactive
            }
            .store(in: &cancellables)
    }

    private func applyStateStyle() {
        layer.borderColor = state.borderColor.cgColor
    }

    private func applyPlaceholderStyle() {
        guard let placeholder else {
            textField.attributedPlaceholder = nil
            return
        }

        let attributes = Constants.placeholderTypography.createLineHeightAttributes()
        textField.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: attributes
        )
    }
}
