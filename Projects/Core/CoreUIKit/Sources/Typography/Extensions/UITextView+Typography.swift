//
//  UITextView+Typography.swift
//  CoreUIKit
//
//  Created by Ren Shin on 2023/06/21.
//  Copyright © 2023 Swit. All rights reserved.
//

import UIKit
import Combine
import CombineCocoa

private enum AssociatedKeys {
    static var typographyKey: UInt8 = 0
}

extension UITextView {
    public var typography: Typography? {
        get { objc_getAssociatedObject(self, &AssociatedKeys.typographyKey) as? Typography }
        set { objc_setAssociatedObject(self, &AssociatedKeys.typographyKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
}

public extension UITextView {
    convenience init(typography: Typography) {
        self.init()
        applyTypography(with: typography)
    }

    func applyTypography(with typography: Typography) {
        font = typography.font
        textAlignment = typography.alignment
        textColor = typography.color

        self.typography = typography
        applyLineHeight(with: typography, fontLineHeight: font?.lineHeight ?? .zero)
    }
}

extension UITextView: LineHeightSettable {
    var attributed: NSAttributedString? {
        get { attributedText }
        set { attributedText = newValue }
    }
}

//MARK: - Publisher
extension UITextView {
    /// A Combine publisher for the `UITextView's` attributedText value.
    ///
    /// - note: This uses the underlying `NSTextStorage` to make sure
    ///         autocorrect changes and attributed text changes are reflected as well.
    var attributedTextPublisher: AnyPublisher<NSAttributedString?, Never> {
        Deferred { [weak textView = self] in
            textView?.textStorage
                .didProcessEditingRangeChangeInLengthPublisher
                .map { _ in textView?.attributedText }
                .prepend(textView?.attributedText)
                .eraseToAnyPublisher() ?? Empty().eraseToAnyPublisher()
        }
        .eraseToAnyPublisher()
    }
}
