//
//  Typography+View.swift
//  CoreUIKit
//
//  Created by 이숭인 on 7/29/25.
//

import Foundation
import SwiftUI

@available(iOS 13.0, *)
public extension View {
    /// Typography를 적용하는 modifier
    func typography(_ typography: Typography) -> some View {
        if #available(iOS 16.0, *) {
            return self
                .font(typography.swiftUIFont.leading(typography.leading))
                .foregroundColor(typography.swiftUIColor)
                .multilineTextAlignment(typography.swiftUIAlignment)
        } else {
            return self
                .font(typography.swiftUIFont)
                .foregroundColor(typography.swiftUIColor)
                .lineSpacing(typography.lineSpacing)
                .multilineTextAlignment(typography.swiftUIAlignment)
        }
    }
}

// MARK: - NavigationTitle Extensions
@available(iOS 14.0, *)
public extension View {
    /// Typography를 적용한 navigationTitle
    func navigationTitle(_ title: String, typography: Typography) -> some View {
        self.navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
    }
}

