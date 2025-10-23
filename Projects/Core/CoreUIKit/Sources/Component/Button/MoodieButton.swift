//
//  MoodieButton.swift
//  CoreUIKit
//
//  Created by 이숭인 on 10/23/25.
//

import UIKit
import SnapKit
import Then
import Combine
import CombineCocoa

public enum MoodieButtonType {
    case active
    case inactive
}

extension MoodieButtonType {
    var height: CGFloat {
        switch self {
        case .active:
            return 56
        case .inactive:
            return 56
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .active:
            return .purple2
        case .inactive:
            return .gray6
        }
    }
    
    var textColor: UIColor {
        switch self {
        case .active:
            return .gray8
        case .inactive:
            return .gray8
        }
    }
}

extension MoodieButton {
    private enum Constants {
        static let titleTypo = Typography(
            fontType: .nanumSquareRound,
            size: .size17,
            weight: .heavy,
            alignment: .center,
            color: .gray8,
            applyLineHeight: true
        )
    }
}

public final class MoodieButton: BaseView {
    //MARK: Properties
    public var onTouchButtonPulbisher: AnyPublisher<Void, Never> {
        tapGesture.tapPublisher
            .filter { [weak self] _ in
                self?.buttonType == .active
            }
            .map { _ in () }
            .eraseToAnyPublisher()
    }
   
    public var buttonType: MoodieButtonType {
        didSet {
            backgroundColor = buttonType.backgroundColor
            titleLabel.textColor = buttonType.textColor
        }
    }
    
    public var title: String? {
        get {
            titleLabel.text
        } set {
            titleLabel.text = newValue
        }
    }
    
    //MARK: UI Components
    private let titleLabel = UILabel(typography: Constants.titleTypo)
    private let tapGesture = UITapGestureRecognizer()
    
    //MARK: Life Cycle
    public init(
        buttonType: MoodieButtonType
    ) {
        self.buttonType = buttonType
        
        super.init(frame: .zero)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func setup() {
        super.setup()
        
        layer.cornerRadius = 16
        addGestureRecognizer(tapGesture)
        backgroundColor = buttonType.backgroundColor
    }
    
    public override func setupSubviews() {
        addSubview(titleLabel)
    }
    
    public override func setupConstraints() {
        self.snp.makeConstraints { make in
            make.height.equalTo(buttonType.height)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.greaterThanOrEqualToSuperview().inset(16)
            make.trailing.lessThanOrEqualToSuperview().inset(16)
        }
    }
}
