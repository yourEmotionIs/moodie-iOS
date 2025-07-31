//
//  Typography+SecureField.swift
//  CoreUIKit
//
//  Created by 이숭인 on 7/29/25.
//

import SwiftUI

@available(iOS 13.0, *)
public extension SecureField where Label == Text {
    /// Typography를 적용한 SecureField 생성
    init(_ titleKey: LocalizedStringKey, text: Binding<String>, typography: Typography) {
        self.init(titleKey, text: text)
    }
    
    init<S>(_ title: S, text: Binding<String>, typography: Typography) where S : StringProtocol {
        self.init(title, text: text)
    }
}
