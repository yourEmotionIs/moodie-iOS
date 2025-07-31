//
//  Typography+Text.swift
//  CoreUIKit
//
//  Created by 이숭인 on 7/29/25.
//

import SwiftUI

@available(iOS 13.0, *)
public extension Text {
    /// Typography를 적용한 Text 생성
    init(_ content: String, typography: Typography) {
        if #available(iOS 15.0, *), typography.applyLineHeight {
            // AttributedString을 사용하여 정확한 라인 높이 적용
            self.init(typography.createAttributedString(for: content))
        } else {
            self.init(content)
            self = self.typography(typography)
        }
    }
    
    /// Typography를 적용하는 modifier (Text 전용)
    func typography(_ typography: Typography) -> Text {
        if #available(iOS 16.0, *) {
            return self
                .font(typography.swiftUIFont.leading(typography.leading))
                .foregroundColor(typography.swiftUIColor)
        } else {
            return self
                .font(typography.swiftUIFont)
                .foregroundColor(typography.swiftUIColor)
        }
    }
}
