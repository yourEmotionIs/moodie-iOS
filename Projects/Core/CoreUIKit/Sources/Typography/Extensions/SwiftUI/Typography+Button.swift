//
//  Typography+Button.swift
//  CoreUIKit
//
//  Created by 이숭인 on 7/29/25.
//

import SwiftUI

@available(iOS 13.0, *)
public extension Button where Label == Text {
    /// Typography를 적용한 Button 생성
    init(_ titleKey: LocalizedStringKey, typography: Typography, action: @escaping () -> Void) {
        self.init(action: action) {
            Text(titleKey)
                .typography(typography)
        }
    }
    
    init<S>(_ title: S, typography: Typography, action: @escaping () -> Void) where S : StringProtocol {
        self.init(action: action) {
            Text(title)
                .typography(typography)
        }
    }
}
